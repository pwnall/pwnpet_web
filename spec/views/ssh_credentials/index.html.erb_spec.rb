require 'spec_helper'

describe "ssh_credentials/index.html.erb" do
  before(:each) do
    assign(:ssh_credentials, [
      stub_model(SshCredential,
        :machine_id => false,
        :username => "Username",
        :password => "Password",
        :key => "MyText"
      ),
      stub_model(SshCredential,
        :machine_id => false,
        :username => "Username",
        :password => "Password",
        :key => "MyText"
      )
    ])
  end

  it "renders a list of ssh_credentials" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
