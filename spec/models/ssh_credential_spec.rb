require 'spec_helper'

describe SshCredential do
  fixtures :machines, :ssh_credentials
    
  before(:all) { @key = SshCredential.new_key }
    
  describe 'password credential' do
    before do
      @credential = SshCredential.new :machine => machines(:bunny1),
                                      :username => 'pwnall',
                                      :password => 'b00mheadsh0t'
    end
      
    it 'should validate' do
      @credential.should be_valid
    end
    
    it 'should have :password in ssh_options' do
      @credential.ssh_options.should have_key(:password)
    end    

    it 'should not validate a credential without the key and the password' do
      @credential.password = nil
      @credential.should_not be_valid
    end
  
    it 'should not validate a credential with both a key and a password' do
      @credential.key = @key
      @credential.should_not be_valid
    end

    it 'should unscramble a fixture password' do
      ssh_credentials(:bunny1_pwnpet).password.should == 'b00mheadsh0t'
    end  

    it 'should unscramble a previously scrambled password' do
      @credential.save
      SshCredential.find(@credential.id).password.should == @credential.password
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
      @credential.username = ssh_credentials(:bunny1_pwnpet).username
      @credential.should_not be_valid
    end
  end
  
  describe 'key credential' do 
    before do
      @credential = SshCredential.new :machine => machines(:bunny1),
                                      :username => 'pwnall', :key => @key
    end

    it 'should validate' do
      @credential.password = nil
      @credential.should be_valid
    end
    
    it 'should have :key_data in ssh_options' do
      @credential.ssh_options.should have_key(:key_data)
    end
  end
end
