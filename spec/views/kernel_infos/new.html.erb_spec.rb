require 'spec_helper'

describe "kernel_infos/new.html.erb" do
  before(:each) do
    assign(:kernel_info, stub_model(KernelInfo,
      :name => "MyString",
      :release => "MyString",
      :version => "MyString",
      :machine => "MyString",
      :os => "MyString"
    ).as_new_record)
  end

  it "renders new kernel_info form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => kernel_infos_path, :method => "post" do
      assert_select "input#kernel_info_name", :name => "kernel_info[name]"
      assert_select "input#kernel_info_release", :name => "kernel_info[release]"
      assert_select "input#kernel_info_version", :name => "kernel_info[version]"
      assert_select "input#kernel_info_machine", :name => "kernel_info[machine]"
      assert_select "input#kernel_info_os", :name => "kernel_info[os]"
    end
  end
end
