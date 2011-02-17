require 'spec_helper'

describe "machines/edit.html.erb" do
  before(:each) do
    @machine = assign(:machine, stub_model(Machine,
      :name => "MyString"
    ))
  end

  it "renders the edit machine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => machines_path(@machine), :method => "post" do
      assert_select "input#machine_name", :name => "machine[name]"
    end
  end
end
