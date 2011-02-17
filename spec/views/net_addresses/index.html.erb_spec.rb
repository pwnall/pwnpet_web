require 'spec_helper'

describe "net_addresses/index.html.erb" do
  before(:each) do
    assign(:net_addresses, [
      stub_model(NetAddress,
        :machine_id => 1,
        :address => "Address"
      ),
      stub_model(NetAddress,
        :machine_id => 1,
        :address => "Address"
      )
    ])
  end

  it "renders a list of net_addresses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
  end
end
