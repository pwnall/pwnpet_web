require 'spec_helper'

describe Machine do
  fixtures :machines, :ssh_credentials, :net_addresses, :users
  
  before do
    @machine = Machine.new :name => 'bunny'
    @machine.user = users(:john)
  end
  
  it 'should require an owner' do
    @machine.user = nil
    @machine.should_not be_valid
  end
  
  it 'should validate with a name' do
    @machine.should be_valid
  end
  
  it 'should require a name' do
    @machine.name = nil
    @machine.should_not be_valid
  end
  
  it 'should require unique names' do
    @machine.name = users(:john).machines.first.name
    @machine.should_not be_valid
  end
  
  it 'should require unique IDs' do
    @machine.uid = machines(:bunny1).uid
    @machine.should_not be_valid
  end
  
  describe 'can_edit?' do
    it "should be true for the machine's owner" do
      @machine.can_edit?(users(:john)).should be_true
    end
    it "should be false for another user" do
      @machine.can_edit?(users(:jane)).should be_false
    end
    it "should be false for the nil user" do
      @machine.can_edit?(nil).should be_false
    end
  end

  describe 'can_access?' do
    it "should be true for the machine's owner" do
      @machine.can_access?(users(:john)).should be_true
    end
    it "should be false for another user" do
      @machine.can_access?(users(:jane)).should be_false
    end
    it "should be false for the nil user" do
      @machine.can_access?(nil).should be_false
    end
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
  
  describe 'shell' do
    describe 'when given a username' do
      before do
        @shell = machines(:bunny1).shell 'RSpec', 'pwnpet'
      end
      after { @shell && @shell.close }

      it 'should return a ShellSession' do
        @shell.should be_kind_of(ShellSession)
      end
      it 'should return a saved record' do
        @shell.should_not be_new_record
      end
      it 'should return a live session' do
        @shell.exec!("echo 42").should == "42\n"
      end
      it 'should return a session for the given machine' do
        @shell.machine.should == machines(:bunny1)
      end
      it 'should return a session with the correct username set' do
        @shell.username.should == 'pwnpet'
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
