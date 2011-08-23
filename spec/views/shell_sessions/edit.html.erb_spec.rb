require 'spec_helper'

describe "shell_sessions/edit.html.erb" do
  before(:each) do
    @shell_session = assign(:shell_session, stub_model(ShellSession,
      :machine_id => 1,
      :username => "MyString",
      :reason => "MyText"
    ))
  end

  it "renders the edit shell_session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shell_sessions_path(@shell_session), :method => "post" do
      assert_select "input#shell_session_machine_id", :name => "shell_session[machine_id]"
      assert_select "input#shell_session_username", :name => "shell_session[username]"
      assert_select "textarea#shell_session_reason", :name => "shell_session[reason]"
    end
  end
end
