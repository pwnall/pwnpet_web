require 'spec_helper'

describe "shell_sessions/index.html.erb" do
  before(:each) do
    assign(:shell_sessions, [
      stub_model(ShellSession,
        :machine_id => 1,
        :username => "Username",
        :reason => "MyText"
      ),
      stub_model(ShellSession,
        :machine_id => 1,
        :username => "Username",
        :reason => "MyText"
      )
    ])
  end

  it "renders a list of shell_sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
