# A computer or VM.
class Machine < ActiveRecord::Base
  # User-friendly machine name.
  validates :name, :presence => true, :length => 1..32  
  # Randomly generated ID. Immutable for the machine's lifetime.
  validates :uid, :presence => true, :length => 32..32, :uniqueness => true
  # Secret token shared by the machine and the management server.
  validates :secret, :presence => true, :length => 64..64

  # DNS or IP addresses that the machine is reachable by.
  has_many :addresses, :class_name => 'NetAddress', :inverse_of => :machine
  # Credentials used to command the machine via SSH.
  has_many :ssh_credentials, :inverse_of => :machine

  # Wraps Net::SSH.start.
  #
  # Args:
  #   username:: the user whose credential will be used to log in
  # 
  # If a block is given, it is passed to Net::SSH.start.
  def ssh_session(username = nil, &block)
    credential = username ? ssh_credential_for(username) :
                            ssh_credentials.first
    # TODO(pwnall): loop through all addresses until one works
    address = addresses.first
    Net::SSH.start address.address, credential.username,
                   credential.ssh_options, &block
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
