# Information used to reach a machine over the network.
class NetAddress < ActiveRecord::Base
  # The machine that the address belongs to.
  belongs_to :machine, :inverse_of => :net_addresses
  validates :machine, :presence => true
  
  # IP address or DNS name used to get to a machine.
  validates :address, :length => 1..64, :presence => true  
end
