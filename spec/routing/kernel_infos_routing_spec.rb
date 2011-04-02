require "spec_helper"

describe KernelInfosController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/kernel_infos" }.should route_to(:controller => "kernel_infos", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/kernel_infos/new" }.should route_to(:controller => "kernel_infos", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/kernel_infos/1" }.should route_to(:controller => "kernel_infos", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/kernel_infos/1/edit" }.should route_to(:controller => "kernel_infos", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/kernel_infos" }.should route_to(:controller => "kernel_infos", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/kernel_infos/1" }.should route_to(:controller => "kernel_infos", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/kernel_infos/1" }.should route_to(:controller => "kernel_infos", :action => "destroy", :id => "1")
    end

  end
end
