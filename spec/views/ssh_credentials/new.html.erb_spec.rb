require 'spec_helper'

describe "ssh_credentials/new.html.erb" do
  before(:each) do
    assign(:ssh_credential, stub_model(SshCredential,
      :machine_id => false,
      :username => "MyString",
      :password => "MyString",
      :key => "MyText"
    ).as_new_record)
  end

  it "renders new ssh_credential form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ssh_credentials_path, :method => "post" do
      assert_select "input#ssh_credential_machine_id", :name => "ssh_credential[machine_id]"
      assert_select "input#ssh_credential_username", :name => "ssh_credential[username]"
      assert_select "input#ssh_credential_password", :name => "ssh_credential[password]"
      assert_select "textarea#ssh_credential_key", :name => "ssh_credential[key]"
    end
  end
end
