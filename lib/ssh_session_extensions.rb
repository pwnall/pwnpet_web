# Mixed in Net::SSH::Connection::Session instances produced by Machine.
module SshSessionExtensions
  # Executes a sudo command, supplying the user's password if necessary.
  #
  # Args:
  #   ssh:: the SSH session used to execute the command
  #   command:: the command to execute (should start with 'sudo ')
  #   input:: optional content to be fed to the program's stdin
  #
  # Returns the program's stdout and stderr.
  def sudo_exec!(command, input = nil)
    unless password = self[:credential].password
      raise ArgumentError, "sudo requires password credential" 
    end
    
    stdout = String.new
    sudo_prompt = nil
    input_sent = !input
    
    ssh_channel = open_channel do |channel|
      channel.request_pty do |_, success|
        raise "Failed to get pty (interactive ssh session)" unless success
      end
      channel.exec command do |_, success|
        raise "Failed to exec command \"#{command}\"" unless success
        channel.on_data do |_, data|
          stdout << data
          if sudo_prompt.nil?
            if separator_index = stdout.index("\n") || stdout.index(":")
              first_line = stdout[0, separator_index]
              sudo_prompt = (/sudo.*password/i =~ first_line) ? true : false
              channel.send_data "#{password}\n" if sudo_prompt
            end
          elsif !input_sent
            channel.send_data input
            channel.send_data "\004"
            channel.eof!
            input_sent = true
          end
        end
        channel.on_extended_data { |_, _, data| stdout << data }
      end
    end
    ssh_channel.wait
    # Remove the sudo prompt from the output.
    sudo_prompt ? stdout[(stdout.index("\n") + 1)..-1] : stdout
  end
end
