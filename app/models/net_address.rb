class NetAddress < ActiveRecord::Base
  # The machine that the address belongs to.
  has_one :machine, :inverse_of => :addresses
  validates :machine, :presence => true
end
