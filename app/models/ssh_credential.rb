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
  def new_key
    self.key = self.class.new_key
  end
  
  # Checks that the credentials work by using them for a SSH session.
  def health_check
    begin
      machine.ssh_session(self) do |ssh|
        return ssh.exec!("echo 42") == "42\n"
      end
    rescue
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
  
  # Installs this credential into a machine via SSH.
  #
  # After this call, the credential can be used to log into the machine. The
  # credential's user should already be created.
  #
  # Args:
  #   ssh:: the Net::SSH session 
  def install(ssh)
    if key
      # SSH key installation.
      home_dir = (username == 'root') ? '/root' : "/home/#{username}"
      ssh_dir = "#{home_dir}/.ssh"
      ssh.sudo_exec! "sudo mkdir -p #{ssh_dir}"
      key_file = "#{ssh_dir}/authorized_keys"
      ssh.sudo_exec! "sudo touch #{key_file}"
      key_data = ssh.sudo_exec! "sudo cat #{key_file}"
      key_line = ssh_authorized_keys_line
      unless key_data.index(key_line)
        ssh.sudo_exec! "sudo sh -c \"cat >> #{key_file}\"", "#{key_line}\n"
      end
    else
      # SSH password installation.
      ssh.sudo_exec! "sudo chpasswd", "#{username}:#{password}\n"
    end
  end
end
