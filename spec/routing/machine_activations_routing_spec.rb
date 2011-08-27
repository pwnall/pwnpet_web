require "spec_helper"

describe MachineActivationsController do
  describe "routing" do

    it "routes to #index" do
      get("/machine_activations").should route_to("machine_activations#index")
    end

    it "routes to #new" do
      get("/machine_activations/new").should route_to("machine_activations#new")
    end

    it "routes to #show" do
      get("/machine_activations/1").should route_to("machine_activations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/machine_activations/1/edit").should route_to("machine_activations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/machine_activations").should route_to("machine_activations#create")
    end

    it "routes to #update" do
      put("/machine_activations/1").should route_to("machine_activations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/machine_activations/1").should route_to("machine_activations#destroy", :id => "1")
    end

  end
end
