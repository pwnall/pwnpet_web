require "spec_helper"

describe NetAddressesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/net_addresses" }.should route_to(:controller => "net_addresses", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/net_addresses/new" }.should route_to(:controller => "net_addresses", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/net_addresses/1" }.should route_to(:controller => "net_addresses", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/net_addresses/1/edit" }.should route_to(:controller => "net_addresses", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/net_addresses" }.should route_to(:controller => "net_addresses", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/net_addresses/1" }.should route_to(:controller => "net_addresses", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/net_addresses/1" }.should route_to(:controller => "net_addresses", :action => "destroy", :id => "1")
    end

  end
end
