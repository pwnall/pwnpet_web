require 'spec_helper'

describe NetAddress do
  fixtures :machines, :net_addresses
  
  before do
    @address = NetAddress.new :machine => machines(:bunny1),
                              :address => 'bunny1.dyndns.ws',
                              :last_used_at => Time.now - 1,
                              :last_failed_at => Time.now - 4
  end
    
  it 'should validate a good address' do
    @address.should be_valid
  end

  it 'should require a machine' do
    @address.machine = nil
    @address.should_not be_valid
  end

  it 'should require an address' do
    @address.address = nil
    @address.should_not be_valid
  end
  
  it 'should accept a nil last_used time' do
    @address.last_used_at = nil
    @address.should be_valid
  end

  it 'should accept a nil last_failed time' do
    @address.last_failed_at = nil
    @address.should be_valid
  end
  
  describe 'with last_used more recent than last_failed' do
    before do
      @address.last_used_at = Time.now - 1
      @address.last_failed_at = Time.now - 3
    end
    it 'should be healthy' do
      @address.should be_healthy
    end
  end
  
  describe 'with last_used less recent than last_failed' do
    before do
      @address.last_used_at = Time.now - 3
      @address.last_failed_at = Time.now - 1
    end
    it 'should not be healthy' do
      @address.should_not be_healthy
    end
  end

  describe 'with no last_used date' do
    before do
      @address.last_used_at = nil
      @address.last_failed_at = Time.now - 3
    end
    it 'should not be healthy' do
      @address.should_not be_healthy
    end
  end

  describe 'with no last_failed date' do
    before do
      @address.last_used_at = Time.now - 1
      @address.last_failed_at = nil
    end
    it 'should be healthy' do
      @address.should be_healthy
    end
  end
  
  describe 'with no last_used and no last_failed date' do
    before do
      @address.last_used_at = nil
      @address.last_failed_at = nil
    end
    it 'should not be healthy' do
      @address.should_not be_healthy
    end
  end
  
  describe 'record_use!' do
    before { @address.record_use! }
    
    it 'should update last_used' do
      @address.last_used_at.to_i.should eq(Time.now.to_i)
    end
    it 'should not change last_failed' do
      @address.last_failed_at.to_i.should_not eq(Time.now.to_i)
    end
  end

  describe 'record_fail!' do
    before { @address.record_fail! }
    
    it 'should update last_failed' do
      @address.last_failed_at.to_i.should eq(Time.now.to_i)
    end
    it 'should not change last_used' do
      @address.last_used_at.to_i.should_not eq(Time.now.to_i)
    end
  end
end
