require "spec_helper"

describe CommandResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/command_results").should route_to("command_results#index")
    end

    it "routes to #new" do
      get("/command_results/new").should route_to("command_results#new")
    end

    it "routes to #show" do
      get("/command_results/1").should route_to("command_results#show", :id => "1")
    end

    it "routes to #edit" do
      get("/command_results/1/edit").should route_to("command_results#edit", :id => "1")
    end

    it "routes to #create" do
      post("/command_results").should route_to("command_results#create")
    end

    it "routes to #update" do
      put("/command_results/1").should route_to("command_results#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/command_results/1").should route_to("command_results#destroy", :id => "1")
    end

  end
end
