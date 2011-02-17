require "spec_helper"

describe SshCredentialsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/ssh_credentials" }.should route_to(:controller => "ssh_credentials", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/ssh_credentials/new" }.should route_to(:controller => "ssh_credentials", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/ssh_credentials/1" }.should route_to(:controller => "ssh_credentials", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/ssh_credentials/1/edit" }.should route_to(:controller => "ssh_credentials", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/ssh_credentials" }.should route_to(:controller => "ssh_credentials", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/ssh_credentials/1" }.should route_to(:controller => "ssh_credentials", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/ssh_credentials/1" }.should route_to(:controller => "ssh_credentials", :action => "destroy", :id => "1")
    end

  end
end
