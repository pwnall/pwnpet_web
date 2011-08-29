require 'spec_helper'

describe ShellSession do
  fixtures :shell_sessions, :machines, :ssh_credentials, :net_addresses, :users
  
  let(:address) { net_addresses :bunny1_mdns }
  let(:credential) { ssh_credentials :bunny1_pwnpet }
  let(:machine) { machines :bunny1 }

  describe '::ssh live session' do
    before do
      @shell = ShellSession.ssh address, credential, 'RSpec'
    end
    after { @shell && @shell.close }

    it 'should extract the machine from net_address' do
      @shell.machine.should == machine
    end
    it 'should record the username' do
      @shell.username.should == 'pwnpet'
    end
    
    it 'should record the use of the net address' do
      address.last_used_at.to_i.should eq(Time.now.to_i)
    end
    
    it 'should record the use of the ssh credential' do
      credential.last_used_at.to_i.should eq(Time.now.to_i)
    end
    
    describe 'exec!' do
      before { @result = @shell.exec! "echo 42" }
      
      it 'should return the stdout' do
        @result.should == "42\n"
      end
    end
  end
  
  describe '::ssh with a failure' do
    before do
      Net::SSH.should_receive(:start).and_raise(Net::SSH::Exception)
      @shell = ShellSession.ssh address, credential, 'RSpec'
    end
    
    it 'should return nil' do
      @shell.should be_nil
    end

    it 'should record the failure on the net address' do
      address.last_failed_at.to_i.should eq(Time.now.to_i)
    end
    
    it 'should record the failure on the ssh credential' do
      credential.last_failed_at.to_i.should eq(Time.now.to_i)
    end
  end
  
  before do
    @session = ShellSession.new
    @session.machine = machine
    @session.username = credential.username
    @session.reason = 'Test validation'
  end
  
  it 'should validate a good session' do
    @session.should be_valid
  end
  
  it 'should require a machine' do
    @session.machine = nil
    @session.should_not be_valid
  end
  
  it 'should reject a nil username' do
    @session.username = nil
    @session.should_not be_valid
  end

  it 'should reject an empty username' do
    @session.username = ''
    @session.should_not be_valid
  end

  it 'should coerce an empty reason to nil' do
    @session.reason = ''
    @session.reason.should be_nil
  end

  it 'should accept a nil reason' do
    @session.reason = nil
    @session.should be_valid
  end
end
