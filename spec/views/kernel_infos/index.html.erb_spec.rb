require 'spec_helper'

describe "kernel_infos/index.html.erb" do
  before(:each) do
    assign(:kernel_infos, [
      stub_model(KernelInfo,
        :name => "Name",
        :release => "Release",
        :version => "Version",
        :machine => "Machine",
        :os => "Os"
      ),
      stub_model(KernelInfo,
        :name => "Name",
        :release => "Release",
        :version => "Version",
        :machine => "Machine",
        :os => "Os"
      )
    ])
  end

  it "renders a list of kernel_infos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Release".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Machine".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Os".to_s, :count => 2
  end
end
