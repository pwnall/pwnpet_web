# Information used to reach a machine over the network.
class NetAddress < ActiveRecord::Base
  # The machine that the address belongs to.
  belongs_to :machine, :inverse_of => :net_addresses
  validates :machine, :presence => true
  
  # IP address or DNS name used to get to a machine.
  validates :address, :length => 1..64, :presence => true
  
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
  def successful_use!
    self.last_used_at = Time.now
    save!
  end
  
  # Reflects the use of this address in a failed connection.
  #
  # This method is called automatically when a ShellSession is established.
  def failed_use!
    self.last_failed_at = Time.now
    save!
  end
end
