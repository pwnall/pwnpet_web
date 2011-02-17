require 'spec_helper'

describe "machines/show.html.erb" do
  before(:each) do
    @machine = assign(:machine, stub_model(Machine,
      :name => "Name",
      :uid => "Uid",
      :secret => "Secret"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Uid/)
  end
end
