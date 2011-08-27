require 'spec_helper'

describe MachineActivation do
  fixtures :machine_activations, :machines, :net_addresses, :ssh_credentials
  
  let(:activation) do
    MachineActivation.new :machine => machines(:activation_test),
                          :password_reset => true, :completed_at => Time.now - 1
  end
  
  it 'should validate a good record' do
    activation.should be_valid
  end
  
  it 'should accept a missing value for completed_at' do
    activation.completed_at = nil
    activation.should be_valid
  end
  
  it 'should reject a non-date value for completed_at' do
    activation.completed_at = 'not valid'
    activation.should_not be_valid
  end
  
  it 'should require a machine' do
    activation.machine = nil
    activation.should_not be_valid
  end
  
  it 'should enforce one activation per machine' do
    activation.machine = machines(:bunny1)
    activation.should_not be_valid
  end
  
  it 'should require a password reset choice' do
    activation.password_reset = nil
    activation.should_not be_valid
  end
  
  it 'should accept no password reset' do
    activation.password_reset = false
    activation.should be_valid
  end
end
