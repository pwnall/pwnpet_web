require 'spec_helper'

describe "machine_activations/index.html.erb" do
  before(:each) do
    assign(:machine_activations, [
      stub_model(MachineActivation,
        :machine_id => 1,
        :password_reset => false
      ),
      stub_model(MachineActivation,
        :machine_id => 1,
        :password_reset => false
      )
    ])
  end

  it "renders a list of machine_activations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
