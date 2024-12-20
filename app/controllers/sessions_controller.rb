class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [ :destroy ]
  skip_before_action :verify_authenticity_token, only: [ :create, :destroy ]

  def index
  end

  def create
    token = params[:token]

    begin
      clerk_session = Clerk::Session.verify(token, ENV["CLERK_SECRET_KEY"])
      user = Clerk::User.find(clerk_session.user_id)

      session[:user_id] = user.id

      render json: { status: "success" }, status: :ok
    rescue Clerk::Error => e
      render json: { status: "error", message: e.message }, status: :unauthorized
    end
  end
end
