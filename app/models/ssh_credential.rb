# Information used to log into a machine via SSH.
class SshCredential < ActiveRecord::Base
  # The machine that this login credential is used for.
  belongs_to :machine
  validates :machine, :presence => true
  
  # The user name used for SSH logins.
  validates :username, :length => 1..32, :presence => true,
                       :uniqueness => { :scope => :machine_id }
  # If non-nil, SSH logins should use this password.
  validates :password, :length => { :in => 1..64, :allow_nil => true }
  # If non-nil, SSH logins should use this key.
  validates :key, :length => { :in => 1..2.kilobytes, :allow_nil => true }
  
  # Last time this address was used to successfully connect to a machine.
  validates :last_used_at, :timeliness => { :type => :datetime,
                                            :allow_nil => true }
  # Last time this address was used in a failed attempt to connect to a machine.
  validates :last_failed_at, :timeliness => { :type => :datetime,
                                              :allow_nil => true }
  
  # True if last connection attempt involving this address succeeded.
  def healthy?
    !last_used_at.nil? && (last_failed_at.nil? || last_used_at > last_failed_at)
  end
  
  # Reflects the use of this address in a successful connection.
  #
  # This method is called automatically when a ShellSession is established.
  def record_use!
    self.last_used_at = Time.now
    save!
  end
  
  # Reflects the use of this address in a failed connection.
  #
  # This method is called automatically when a ShellSession is established.
  def record_fail!
    self.last_failed_at = Time.now
    save!
  end
  
  # :nodoc: credentials should either have a password or a key
  def require_password_or_key
  	if scrambled_password.nil? && key.nil?
  	  errors[:password] << 'must be set if no SSH key is present'
  	  errors[:key] << 'must be set if no password is present'
  	elsif !scrambled_password.nil? && !key.nil?
      errors[:password] << 'cannot be set if a SSH key is also set'
      errors[:key] << 'cannot be set if a password is also set'
  	end
  end
  validate :require_password_or_key
  
  # Changes the real (unscrambled) password.
  def password=(new_password)
    new_password = nil if new_password.blank?
    self.scrambled_password = new_password &&
                              self.class.scramble_password(new_password)
  end
  
  # The real (unscrambled) password.
  def password
    scrambled_password && scrambled_password.unpack('m').first
  end
  
  # :nodoc: override key= to turn an empty string into nil
  def key=(new_key)
    new_key = nil if new_key.blank?
    super(new_key)
  end
  
  # Generates a new key and assigns it to the key field.
  def new_key!
    self.key = self.class.new_key
    self
  end
  
  # Checks that the credentials work by using them for a SSH session.
  def health_check
    begin
      session = machine.shell 'Verify SSH credential', self
      result = session && session.exec!("echo 42") == "42\n"
      session.close if session
      result
    rescue Net::SSH::Exception
      return false
    end
  end
  
  # A hash with the SSH options conveying this credential.
  def ssh_options
    if key
      { :key_data => [key] }
    else
      { :password => password }
    end
  end
  
  # Entry in the ~/.ssh/authorized_keys file.
  #
  # This only works for key credentials.
  def ssh_authorized_keys_line
    ssl_key = OpenSSL::PKey::RSA.new key
    [
      ssl_key.ssh_type,
      [ssl_key.public_key.to_blob].pack('m').gsub("\n", ''),
      "#{username}@pwnpet"
    ].join(' ')
  end
  
  # True if superuser commands should be issued using sudo.
  def needs_sudo?
    username != 'root'
  end
  
  # Password scrambling mechanism, to be used in fixtures.
  def self.scramble_password(password)
    [password].pack('m')
  end
  
  # Generates a keypair.
  def self.new_key
    OpenSSL::PKey::RSA.new(2048).to_pem
  end
  
  # Installs this credential into a machine via a command shell session.
  #
  # After this call, the credential can be used to log into the machine. The
  # credential's user should already be created.
  #
  # Args:
  #   shell_session:: the ShellSession used to install the credentials; the
  #                   session should have superuser privileges (sudo)
  def install(shell_session)
    if key
      # SSH public key.
      home_dir = (username == 'root') ? '/root' : "/home/#{username}"
      ssh_dir = "#{home_dir}/.ssh"
      shell_session.sudo_exec! "sudo mkdir -p #{ssh_dir}"
      key_file = "#{ssh_dir}/authorized_keys"
      shell_session.sudo_exec! "sudo touch #{key_file}"
      key_data = shell_session.sudo_exec! "sudo cat #{key_file}"
      key_line = ssh_authorized_keys_line
      unless key_data.index(key_line)
        shell_session.sudo_exec! %Q|sudo sh -c "cat >> #{key_file}"|,
                                 key_line + "\n"
      end
    else
      # Login password.
      shell_session.sudo_exec! "sudo chpasswd", "#{username}:#{password}\n"
    end
  end
end
