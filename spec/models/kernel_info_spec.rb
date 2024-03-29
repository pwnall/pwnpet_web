require 'spec_helper'

describe KernelInfo do
  fixtures :kernel_infos, :machines, :ssh_credentials, :net_addresses
  
  before do
    @info = KernelInfo.new :machine => machines(:bunny2),
        :name => 'Linux', :release => '3.0-2-generic',
        :version => '#3-Ubuntu SMP Fri Jun 24 19:09:43 UTC 2011',
        :architecture => 'i686', :os => 'GNU/Linux'
  end
  
  it 'should validate healthy data' do
    @info.should be_valid
  end
  
  it 'should require a name' do
    @info.name = nil
    @info.should_not be_valid
  end

  it 'should require a release' do
    @info.release = nil
    @info.should_not be_valid
  end

  it 'should require a version' do
    @info.version = nil
    @info.should_not be_valid
  end

  it 'should require an architecture' do
    @info.architecture = nil
    @info.should_not be_valid
  end

  it 'should require an OS name' do
    @info.os = nil
    @info.should_not be_valid
  end
  
  it 'should require a machine' do
    @info.machine = nil
    @info.should_not be_valid
  end
  
  it 'should enforce machine uniqueness' do
    @info.machine = kernel_infos(:bunny1).machine
    @info.should_not be_valid
  end
  
  describe 'update_from_shell' do
    describe 'with given session' do
      let(:session) { mock('ssh session', :exec! => 'exec result') }

      before do
        @info.update_from_shell session
      end
      
      it 'should use the session' do
        @info.name.should == 'exec result'
      end
    end
    
    describe 'without a given session' do
      before do
        @info = KernelInfo.new :machine => machines(:bunny1)
        @info.update_from_shell
      end
      
      it 'should use the machine session' do
        @info.name.should == 'Linux'
      end
      
      it 'should fetch the release correctly' do
        @info.release.should match(/^[2-3]\.\d/)
      end

      it 'should fetch the version correctly' do
        @info.version.should match(/^\#/)
      end
      
      it 'should fetch the OS name correctly' do
        @info.os.should match(/linux/i)
      end
      
      it 'should fetch the architecture correctly' do
        @info.architecture.should == 'i686'
      end
    end
  end
end
