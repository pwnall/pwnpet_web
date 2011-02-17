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
  	if password.nil? && key.nil?
  	  errors[:password] << 'must be set if no SSH key is present'
  	  errors[:key] << 'must be set if no password is present'
  	elsif !password.nil? && !key.nil?
      errors[:password] << 'cannot be set if a SSH key is also set'
      errors[:key] << 'cannot be set if a password is also set'
  	end
  end
  validate :require_password_or_key
  
  # :nodoc: scrambles password so it's not trivial to read it in the database
  def scramble_password
    self.password = self.class.scramble_password(password) if password
  end
  before_save :scramble_password
  
  # :nodoc: de-scrambles password so it can be used
  def unscramble_password    
    self.password = password.unpack('m').first if password
  end
  after_save :unscramble_password
  after_initialize :unscramble_password
  
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
    OpenSSL::PKey::RSA.new(2048).to_der
  end
end
