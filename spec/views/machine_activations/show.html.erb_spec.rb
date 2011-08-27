require 'spec_helper'

describe "machine_activations/show.html.erb" do
  before(:each) do
    @machine_activation = assign(:machine_activation, stub_model(MachineActivation,
      :machine_id => 1,
      :password_reset => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
