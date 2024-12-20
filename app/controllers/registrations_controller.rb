class RegistrationsController < ApplicationController
  skip_before_action :require_clerk_session

  def new
  end
end
