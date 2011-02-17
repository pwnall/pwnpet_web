require 'spec_helper'

describe "machines/index.html.erb" do
  before(:each) do
    assign(:machines, [
      stub_model(Machine,
        :name => "Name",
        :uid => "Uid",
        :secret => "Secret"
      ),
      stub_model(Machine,
        :name => "Name",
        :uid => "Uid",
        :secret => "Secret"
      )
    ])
  end

  it "renders a list of machines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Secret".to_s, :count => 2
  end
end
