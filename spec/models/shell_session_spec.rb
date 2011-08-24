require 'spec_helper'

describe ShellSession do
  fixtures :shell_sessions, :machines, :ssh_credentials, :net_addresses, :users
  
  
  describe '::ssh live session' do
    before do
      @shell = ShellSession.ssh net_addresses(:bunny1_mdns),
                                ssh_credentials(:bunny1_pwnpet), 'RSpec'
    end
    after { @shell && @shell.close }

    it 'should extract the machine from net_address' do
      @shell.machine.should == machines(:bunny1)
    end
    it 'should record the username' do
      @shell.username.should == 'pwnpet'
    end
    
    describe 'exec!' do
      before { @result = @shell.exec! "echo 42" }
      
      it 'should return the stdout' do
        @result.should == "42\n"
      end
    end
  end
  
  before do
    @session = ShellSession.new
    @session.machine = machines(:bunny1)
    @session.username = ssh_credentials(:bunny1_pwnpet).username
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
