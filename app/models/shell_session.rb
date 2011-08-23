# Issues commands to pwnpet machines, and logs the history of commands issued.
#
# Live sessions should be created by calling ShellSession::ssh. A live session
# is used to issue a sequence of commands, and then closed. This model should
# never be instantiated based on params from a Web request.
class ShellSession < ActiveRecord::Base
  # The machine that the session is open to.
  belongs_to :machine
  validates :machine, :presence => true
  attr_protected :machine
  
  # The username used to log in on the machine for this session.
  validates :username, :presence => true, :length => 1..32
  attr_protected :username
  
  # User-friendly motivation why the commands in this session were issued.
  validates :reason, :length => { :in => 1..1024, :allow_nil => true,
                                  :allow_blank => false }
  # :nodoc: convert empty strings to nil
  def reason=(new_reason)
    new_reason = nil if new_reason.blank?
    super new_reason
  end
    
  # Net::SSH session behind a live shell session.
  #
  # This is an implementation detail.
  attr_accessor :net_ssh
  protected :net_ssh, :net_ssh=
  
  # Creates a live SSH session backed by Net::SSH.
  #
  # Returns a ShellSession instance, or nil if the ssh session could not be
  # established.
  #
  # Args:
  #   net_address:: NetAddress instance pointing to the address to connect to
  #   ssh_credential:: SshCredential instance used to log in
  #   reason:: value for the session's reason field
  def self.ssh(net_address, ssh_credential, reason)
    machine = net_address.machine
    address = net_address.address
    username = credential.username
    
    # TODO(pwnall): look into generating a file with the known key for this
    #               host, to prevent MITM attacks
    opts = {
      :global_known_hosts_file => [], :user_known_hosts_file => [],
      :paranoid => false
    }.merge credential.ssh_options
    
    begin
      net_ssh = Net::SSH.start address, username, options
      session = self.create! :machine => machine, :username => username,
                             :reason => reason
      session.net_ssh = net_ssh
      session
    rescue Net::SSH::Exception
      nil
    end
  end
  
  # Closes a live shell session. This shell session will never be live again.
  #
  # Raises an error if this shell session is not live.
  def close
    @net_ssh.close
    @net_ssh = nil
  end
  
  # Executes a sudo command, supplying the user's password if necessary.
  #
  # Args:
  #   command:: the command to execute (should start with 'sudo ')
  #
  # Returns the program's stdout and stderr.
  def exec!(command)
    @net_ssh.exec! command
  end

  # Executes a sudo command, supplying the user's password if necessary.
  #
  # Args:
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
    
    ssh_channel = @net_ssh.open_channel do |channel|
      channel.request_pty do |_, success|
        raise "Failed to get pty (interactive ssh session)" unless success
      end
      channel.exec command do |_, success|
        raise "Failed to exec command \"#{command}\"" unless success
        channel.on_data do |_, data|
          stdout << data
          if sudo_prompt.nil?
            if /sudo[^\n]*password/i =~ stdout
              sudo_prompt = true
              channel.send_data "#{password}\n"
            else
              lines = stdout.split("\n").map(&:strip).reject(&:empty?)
              unless lines.all? { |line| /sudo/ =~ line }
                sudo_prompt = false
              end
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
