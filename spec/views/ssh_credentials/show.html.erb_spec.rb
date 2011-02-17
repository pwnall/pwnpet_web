require 'spec_helper'

describe "ssh_credentials/show.html.erb" do
  before(:each) do
    @ssh_credential = assign(:ssh_credential, stub_model(SshCredential,
      :machine_id => false,
      :username => "Username",
      :password => "Password",
      :key => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Username/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
