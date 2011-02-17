require 'spec_helper'

describe SshCredential do
  fixtures :machines
  
  before do
    @credential = SshCredential.new :machine => machines(:bunny1),
                                    :username => 'pwntest',
                                    :password => 'boomheadsh00t'
    @key = SshCredential.new_key
  end
  
  it 'should require a machine' do
    @credential.machine = nil
    @credential.should_not be_valid
  end

  it 'should require a username' do
    @credential.username = nil
    @credential.should_not be_valid
  end
  
  it 'should validate a password credential' do
    @credential.save!
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
end
