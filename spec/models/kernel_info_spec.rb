require 'spec_helper'

describe KernelInfo do
  fixtures :kernel_infos, :machines, :ssh_credentials, :net_addresses
  
  before do
    @info = KernelInfo.new :machine => machines(:bunny2),
        :name => 'Linux', :release => '2.6.38-3-generic',
        :version => '#49-Ubuntu SMP Tue Mar 1 14:39:03 UTC 2011',
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
  
  describe 'update_by_ssh' do
    describe 'with given session' do
      let(:session) { mock('ssh session', :exec! => 'exec result') }

      before do
        @info.update_by_ssh session
      end
      
      it 'should use the session' do
        @info.name.should == 'exec result'
      end
    end
    
    describe 'without a given session' do
      before do
        @info = KernelInfo.new :machine => machines(:bunny1)
        @info.update_by_ssh
      end
      
      it 'should use the machine session' do
        @info.name.should == 'Linux'
      end
      
      it 'should fetch the release correctly' do
        @info.release.should match(/^2\.6/)
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
