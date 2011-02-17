require 'spec_helper'

describe NetAddress do
  fixtures :machines, :net_addresses
  
  before do
    @address = NetAddress.new :machine => machines(:bunny1),
                              :address => 'bunny1.dyndns.ws'
  end
    
  it 'should validate a good address' do
    @address.should be_valid
  end

  it 'should require a machine' do
    @address.machine = nil
    @address.should_not be_valid
  end

  it 'should require an address' do
    @address.address = nil
    @address.should_not be_valid
  end
end
