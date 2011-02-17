require 'spec_helper'

describe "SshCredentials" do
  describe "GET /ssh_credentials" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get ssh_credentials_path
      response.status.should be(200)
    end
  end
end
