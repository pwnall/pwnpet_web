# Issues commands to pwnpet machines, and logs the history of commands issued.
#
# Live sessions should be created by calling ShellSession::ssh. A live session
# is used to issue a sequence of commands, and then closed. This model should
# never be instantiated based on params from a Web request.
class ShellSession < ActiveRecord::Base
  # The machine that the session is open to.
  belongs_to :machine, :inverse_of => :shell_sessions
  validates :machine, :presence => true
  
  # The username used to log in on the machine for this session.
  validates :username, :presence => true, :length => 1..32
  
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
  # This is set in ShellSession::ssh and should not be modified anywhere else.
  def net_ssh=(new_net_ssh)
    unless new_record?
      raise "Please don't mess with net_ssh="
    end
    @net_ssh = new_net_ssh
  end
  
  # SshCredential used for a live session.
  #
  # This is set in ShellSession::ssh and should not be modified anywhere else.
  # 
  def live_ssh_credential=(new_live_ssh_credential)
    unless new_record?
      raise "Please don't mess with live_ssh_credential="
    end
    @live_ssh_credential = new_live_ssh_credential
  end
  
  # Attributes that can be modified by Web forms.
  attr_accessible :reason
  
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
    username = ssh_credential.username
    
    # TODO(pwnall): look into generating a file with the known key for this
    #               host, to prevent MITM attacks
    ssh_options = {
      :global_known_hosts_file => [], :user_known_hosts_file => [],
      :paranoid => false
    }.merge ssh_credential.ssh_options
    
    begin
      net_ssh = Net::SSH.start address, username, ssh_options
      shell = self.new
      shell.machine = machine
      shell.username = username
      shell.reason = reason
      shell.net_ssh = net_ssh
      shell.live_ssh_credential = ssh_credential
      shell.save!
      shell
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
              unless password = @live_ssh_credential.password
                raise ArgumentError, "sudo requires password credential" 
              end
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
