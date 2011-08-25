require 'spec_helper'

describe "command_results/index.html.erb" do
  before(:each) do
    assign(:command_results, [
      stub_model(CommandResult,
        :shell_session_id => 1,
        :command => "MyText",
        :stdin => "MyText",
        :stdout => "MyText",
        :stderr => "MyText",
        :exit_code => 1
      ),
      stub_model(CommandResult,
        :shell_session_id => 1,
        :command => "MyText",
        :stdin => "MyText",
        :stdout => "MyText",
        :stderr => "MyText",
        :exit_code => 1
      )
    ])
  end

  it "renders a list of command_results" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
