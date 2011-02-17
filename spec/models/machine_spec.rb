require 'spec_helper'

describe Machine do
  fixtures :machines
  
  before do
    @machine = Machine.new :name => 'bunny'
  end
  
  it 'should validate with a name' do
    @machine.save!
    @machine.should be_valid
  end
  
  it 'should require a name' do
    @machine.name = nil
    @machine.should_not be_valid
  end
  
  it 'should require unique IDs' do
    @machine.uid = machines(:bunny1).uid
    @machine.should_not be_valid
  end
  
  describe 'from_mdns' do
    before(:all) do
      @machines = Machine.from_mdns
    end
    it 'should have at least 1 machine (self)' do
      @machines.should have_at_least(1).machine
    end
    
    describe 'first machine' do
      let(:machine) { @machines.first }
      it 'should have a name' do
        machine[:name].should_not be_nil
      end
      it 'should have a non-nil address' do
        machine[:address].should_not be_nil
      end
      it 'should have an address that resolves to an IP' do
        Socket.getaddrinfo(machine[:address], Socket::AF_INET).should_not be_nil
      end
    end
  end
end
