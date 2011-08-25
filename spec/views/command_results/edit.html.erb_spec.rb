require 'spec_helper'

describe "command_results/edit.html.erb" do
  before(:each) do
    @command_result = assign(:command_result, stub_model(CommandResult,
      :shell_session_id => 1,
      :command => "MyText",
      :stdin => "MyText",
      :stdout => "MyText",
      :stderr => "MyText",
      :exit_code => 1
    ))
  end

  it "renders the edit command_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => command_results_path(@command_result), :method => "post" do
      assert_select "input#command_result_shell_session_id", :name => "command_result[shell_session_id]"
      assert_select "textarea#command_result_command", :name => "command_result[command]"
      assert_select "textarea#command_result_stdin", :name => "command_result[stdin]"
      assert_select "textarea#command_result_stdout", :name => "command_result[stdout]"
      assert_select "textarea#command_result_stderr", :name => "command_result[stderr]"
      assert_select "input#command_result_exit_code", :name => "command_result[exit_code]"
    end
  end
end
