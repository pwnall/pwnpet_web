require 'spec_helper'

describe "net_addresses/edit.html.erb" do
  before(:each) do
    @net_address = assign(:net_address, stub_model(NetAddress,
      :machine_id => 1,
      :address => "MyString"
    ))
  end

  it "renders the edit net_address form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => net_addresses_path(@net_address), :method => "post" do
      assert_select "input#net_address_machine_id", :name => "net_address[machine_id]"
      assert_select "input#net_address_address", :name => "net_address[address]"
    end
  end
end
