require 'spec_helper'

describe "net_addresses/show.html.erb" do
  before(:each) do
    @net_address = assign(:net_address, stub_model(NetAddress,
      :machine_id => 1,
      :address => "Address"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address/)
  end
end
