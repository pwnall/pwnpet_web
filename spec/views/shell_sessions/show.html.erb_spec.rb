require 'spec_helper'

describe "shell_sessions/show.html.erb" do
  before(:each) do
    @shell_session = assign(:shell_session, stub_model(ShellSession,
      :machine_id => 1,
      :username => "Username",
      :reason => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Username/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
