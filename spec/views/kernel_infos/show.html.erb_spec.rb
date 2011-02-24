require 'spec_helper'

describe "kernel_infos/show.html.erb" do
  before(:each) do
    @kernel_info = assign(:kernel_info, stub_model(KernelInfo,
      :name => "Name",
      :release => "Release",
      :version => "Version",
      :machine => "Machine",
      :os => "Os"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Release/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Machine/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Os/)
  end
end
