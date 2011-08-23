require 'spec_helper'

describe "shell_sessions/new.html.erb" do
  before(:each) do
    assign(:shell_session, stub_model(ShellSession,
      :machine_id => 1,
      :username => "MyString",
      :reason => "MyText"
    ).as_new_record)
  end

  it "renders new shell_session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shell_sessions_path, :method => "post" do
      assert_select "input#shell_session_machine_id", :name => "shell_session[machine_id]"
      assert_select "input#shell_session_username", :name => "shell_session[username]"
      assert_select "textarea#shell_session_reason", :name => "shell_session[reason]"
    end
  end
end
