require "clerk/authenticatable"
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Clerk::Authenticatable
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user


  def current_user
    @current_user ||= clerk_user
  end
end
