# A computer or VM.
class Machine < ActiveRecord::Base
  # The user that the machine belongs to.
  belongs_to :user, :inverse_of => :machines
  validates :user, :presence => true
  
  # User-friendly machine name.
  validates :name, :presence => true, :length => 1..32,
                   :uniqueness => { :scope => :user_id }
  # Randomly generated ID. Immutable for the machine's lifetime.
  validates :uid, :presence => true, :length => 32..32, :uniqueness => true
  # Secret token shared by the machine and the management server.
  validates :secret, :presence => true, :length => 64..64

  # DNS or IP addresses that the machine is reachable by.
  has_many :net_addresses, :inverse_of => :machine, :dependent => :destroy
  accepts_nested_attributes_for :net_addresses, :allow_destroy => true
  # Credentials used to command the machine via SSH.
  has_many :ssh_credentials, :inverse_of => :machine, :dependent => :destroy
  accepts_nested_attributes_for :ssh_credentials, :allow_destroy => true
  
  # Command shell sessions established to this machine.
  has_many :shell_sessions, :inverse_of => :machine, :dependent => :destroy

  # Information about getting this machine under PwnPet's control.  
  has_one :activation, :class_name => 'MachineActivation',
                       :inverse_of => :machine, :dependent => :destroy
  
  # Forms can only update these attributes.
  attr_accessible :name, :net_addresses_attributes, :ssh_credentials_attributes
  
  # True if the user can edit the data connected to this machine.
  #
  # Users that can edit data can directly access sensitive things such as
  # the SSH credentials (password / SSH key) used to root into the machine.
  def can_edit?(user)
    user == self.user
  end
  
  # True if the user can establish a SSH session to the machine.
  def can_access?(user)
    user == self.user
  end

  # Creates a live command shell session connected to this machine.
  #
  # Args:
  #   reason:: explanation for the shell session, logged and user-visible
  #   username_or_credential:: credentials to be used for logging in, or the
  #                            username whose credentials will be used to log in
  #
  # Returns a ShellSession 
  def shell(reason = nil, username_or_credential = nil)
    if username_or_credential && username_or_credential.respond_to?(:to_str)
      credential = ssh_credential_for username_or_credential
    else
      credential = username_or_credential || ssh_credentials.first
    end
    # TODO(pwnall): loop through all addresses until one works
    address = net_addresses.first
    
    ShellSession.ssh address, credential, reason
  end
  
  # The SSH login information for a username. nil if not found
  def ssh_credential_for(username)
    ssh_credentials.where(:username => username).first
  end

  # Populates the auto-generated fields for a machine.
  def generate_identity
    self.uid ||= OpenSSL::Random.random_bytes(16).unpack('H*').first
    self.secret ||= OpenSSL::Random.random_bytes(32).unpack('H*').first
    true
  end
  before_validation :generate_identity
  
  # Machines on the same network, obtained using mDNS queries.
  def self.from_mdns(timeout = 2, service = '_workstation._tcp')
    # TODO(pwnall): synchronization, better thread handling
    machines = []
    dnssd_asnyc = DNSSD.browse service do |reply|
      dnssd_async2 = DNSSD.resolve reply do |r|
        machine = { :name => reply.name, :address => r.target }
        machines << machine
        break
      end
      sleep timeout - 0.5
      dnssd_async2.stop
    end
    sleep timeout
    dnssd_async.stop rescue nil
    machines.each { |machine| machine[:address].gsub!(/\.$/, '') }
    machines
  end
end
