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
    describe 'when given a block' do
      before :each do
        machines(:bunny1).ssh_session do |ssh|
          @yield_session = ssh
          @yield_result = ssh.exec!("echo 42")
        end
      end
      
      it 'should yield a session' do
        @yield_result.should == "42\n"
      end
      it 'should yield a session with the credential used' do
        @yield_session[:credential].should == ssh_credentials(:bunny1_pwnpet)
      end
      it 'should yield a session with the address used' do
        @yield_session[:address].should == net_addresses(:bunny1_mdns)
      end
    end
    
    describe 'when not given a block' do
      before(:each) { @ssh_session = machines(:bunny1).ssh_session }
      after(:each) { @ssh_session.close }

      it 'should return a session' do
        @ssh_session.exec!("echo 42").should == "42\n"
      end
      it 'should return a session with the credential used' do
        @ssh_session[:credential].should == ssh_credentials(:bunny1_pwnpet)
      end
      it 'should return a session with the address used' do
        @ssh_session[:address].should == net_addresses(:bunny1_mdns)
      end
    end
  end
  
  describe 'from_mdns' do
    before(:all) do
      @mdns_machines = Machine.from_mdns
    end
    it 'should have at least 1 machine (self)' do
      @mdns_machines.should have_at_least(1).machine
    end
    
    describe 'first machine' do
      let(:machine) { @mdns_machines.first }
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
