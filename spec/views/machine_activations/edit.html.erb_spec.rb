require 'spec_helper'

describe "machine_activations/edit.html.erb" do
  before(:each) do
    @machine_activation = assign(:machine_activation, stub_model(MachineActivation,
      :machine_id => 1,
      :password_reset => false
    ))
  end

  it "renders the edit machine_activation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => machine_activations_path(@machine_activation), :method => "post" do
      assert_select "input#machine_activation_machine_id", :name => "machine_activation[machine_id]"
      assert_select "input#machine_activation_password_reset", :name => "machine_activation[password_reset]"
    end
  end
end
