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

  # Populates the auto-generated fields for a machine.
  def generate_identity
    self.uid ||= OpenSSL::Random.random_bytes(16).unpack('H*').first
    self.secret ||= OpenSSL::Random.random_bytes(32).unpack('H*').first
    true
  end
  before_validation :generate_identity
  
  # Machines on the same network, obtained using mDNS queries.
  def self.from_mdns(timeout = 1, service = '_workstation._tcp')
    machines = []
    dnssd_asnyc = DNSSD.browse service do |reply|
      machine = { :name => reply.name, :address => nil }
      DNSSD.resolve reply do |r|
        machine[:address] = r.target
        break
      end
      machines << machine
    end
    sleep 1
    dnssd_async.stop rescue nil
    machines.each { |machine| machine[:address].gsub!(/\.$/, '') }
    machines
  end
end
