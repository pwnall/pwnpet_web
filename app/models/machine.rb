# A computer or VM.
class Machine < ActiveRecord::Base
  # User-friendly machine name.
  validates :name, :presence => true, :length => 1..32
  # Randomly generated ID. Immutable for the machine's lifetime.
  validates :uid, :presence => true, :length => 32..32, :uniqueness => true
  # Secret token shared by the machine and the management server.
  validates :secret, :presence => true, :length => 64..64

  # DNS or IP addresses that the machine is reachable by.
  has_many :net_addresses, :inverse_of => :machine
  accepts_nested_attributes_for :net_addresses, :allow_destroy => true
  # Credentials used to command the machine via SSH.
  has_many :ssh_credentials, :inverse_of => :machine
  accepts_nested_attributes_for :ssh_credentials, :allow_destroy => true

  # Wraps Net::SSH.start.
  #
  # Args:
  #   username_or_credential:: credential to be used for logging in, or the
  #                            username whose credential will be used to log in
  #
  # Returns a Net::SSH::Session 
  #
  # If a block is given, the SSH session is given to it, and then closed when
  # the block completes.
  def ssh_session(username_or_credential = nil)
    if username_or_credential && username_or_credential.respond_to?(:to_str)
      credential = ssh_credential_for username_or_credential
    else
      credential = username_or_credential || ssh_credentials.first
    end
    user = credential.username
    # TODO(pwnall): look into generating a file with the known key for this
    #               host, to prevent MITM attacks
    opts = {
      :global_known_hosts_file => [], :user_known_hosts_file => [],
      :paranoid => false
    }.merge credential.ssh_options
    # TODO(pwnall): loop through all addresses until one works
    address = net_addresses.first
    addr = address.address
    if Kernel.block_given?
      Net::SSH.start addr, user, opts do |session|
        session[:credential] = credential
        session[:address] = address
        class <<session
          include SshSessionExtensions
        end
        yield session
      end
    else
      session = Net::SSH.start addr, user, opts
      session[:credential] = credential
      session[:address] = address
      class <<session
        include SshSessionExtensions
      end
      session
    end
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
