require 'spec_helper'

describe "machine_activations/new.html.erb" do
  before(:each) do
    assign(:machine_activation, stub_model(MachineActivation,
      :machine_id => 1,
      :password_reset => false
    ).as_new_record)
  end

  it "renders new machine_activation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => machine_activations_path, :method => "post" do
      assert_select "input#machine_activation_machine_id", :name => "machine_activation[machine_id]"
      assert_select "input#machine_activation_password_reset", :name => "machine_activation[password_reset]"
    end
  end
end
