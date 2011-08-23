require "spec_helper"

describe ShellSessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/shell_sessions").should route_to("shell_sessions#index")
    end

    it "routes to #new" do
      get("/shell_sessions/new").should route_to("shell_sessions#new")
    end

    it "routes to #show" do
      get("/shell_sessions/1").should route_to("shell_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/shell_sessions/1/edit").should route_to("shell_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/shell_sessions").should route_to("shell_sessions#create")
    end

    it "routes to #update" do
      put("/shell_sessions/1").should route_to("shell_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/shell_sessions/1").should route_to("shell_sessions#destroy", :id => "1")
    end

  end
end
