class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # TODO(pwnall): account-based authentication
  unless Rails.env.test?
    config_vars_auth
  end
end
