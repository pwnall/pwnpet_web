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
end
