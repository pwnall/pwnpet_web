require 'spec_helper'

describe SshCredential do
  fixtures :machines, :ssh_credentials
  
  before :all do
    @key = SshCredential.new_key
  end
  before do
    @credential = SshCredential.new :machine => machines(:bunny1),
                                    :username => 'pwnall',
                                    :password => 'b00mheadsh0t'
  end
  
  it 'should require a machine' do
    @credential.machine = nil
    @credential.should_not be_valid
  end

  it 'should require a username' do
    @credential.username = nil
    @credential.should_not be_valid
  end
  
  it 'should reject a machine-username duplicate' do
    @credential.username = ssh_credentials(:bunny1_pwntest).username
    @credential.should_not be_valid
  end
  
  it 'should validate a password credential' do
    @credential.should be_valid
  end
  
  it 'should validate a key credential' do
    @credential.password = nil
    @credential.key = @key
    @credential.should be_valid
  end
  
  it 'should not validate a credential without key and password' do
    @credential.password = nil
    @credential.should_not be_valid
  end
  
  it 'should not validate a credential with both a key and a password' do
    @credential.key = @key
    @credential.should_not be_valid
  end
  
  it 'should unscramble a fixture password' do
    ssh_credentials(:bunny1_pwntest).password.should == 'b00mheadsh0t'
  end
  
  it 'should unscramble a previously scrambled password' do
    @credential.save
    SshCredential.find(@credential.id).password.should == @credential.password
  end
end
