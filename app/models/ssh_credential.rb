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
    self.scrambled_password = new_password &&
                              self.class.scramble_password(new_password)
  end
  
  # The real (unscrambled) password.
  def password
    scrambled_password && scrambled_password.unpack('m').first
  end
  
  # A hash with the SSH options conveying this credential.
  def ssh_options
    if key
      { :key_data => [key] }
    else
      { :password => password }
    end
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
end
