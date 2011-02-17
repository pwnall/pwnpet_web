require 'spec_helper'

describe "ssh_credentials/edit.html.erb" do
  before(:each) do
    @ssh_credential = assign(:ssh_credential, stub_model(SshCredential,
      :machine_id => false,
      :username => "MyString",
      :password => "MyString",
      :key => "MyText"
    ))
  end

  it "renders the edit ssh_credential form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ssh_credentials_path(@ssh_credential), :method => "post" do
      assert_select "input#ssh_credential_machine_id", :name => "ssh_credential[machine_id]"
      assert_select "input#ssh_credential_username", :name => "ssh_credential[username]"
      assert_select "input#ssh_credential_password", :name => "ssh_credential[password]"
      assert_select "textarea#ssh_credential_key", :name => "ssh_credential[key]"
    end
  end
end
