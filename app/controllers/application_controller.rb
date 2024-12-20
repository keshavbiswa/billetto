require "clerk/authenticatable"
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Clerk::Authenticatable
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  before_action :authenticate_user!

  def current_user
    @current_user ||= clerk_user
  end

  private

  def authenticate_user!
    unless current_user
      redirect_to sessions_path, turbo: false
    end
  end
end
