require 'spec_helper'

describe Machine do
  fixtures :machines, :ssh_credentials, :net_addresses
  
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
  
  describe 'ssh_credential_for' do
    let(:credential) { machines(:bunny2).ssh_credential_for 'root' }
    it 'should return a SshCredential for a known user account' do
      credential.should_not be_nil
    end
    
    it 'should return a SshCredential matching the username' do
      credential.username.should == 'root'
    end

    it 'should return a SshCredential matching the machine' do
      credential.machine.should == machines(:bunny2)
    end
    
    it 'should return nil for an unknown account' do
      machines(:bunny2).ssh_credential_for('unknown').should be_nil
    end
  end
  
  describe 'ssh_session' do
    it 'should yield when given a block' do
      machines(:bunny1).ssh_session do |ssh|
        ssh.exec!("echo 42").should == "42\n"
      end
    end
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
