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

  def destroy
    if current_user
        Clerk.sign_out(current_user.clerk_session_id)
    end

    session[:user_id] = nil

    respond_to do |format|
      format.html { redirect_to sessions_path, notice: "Successfully logged out." }
      format.turbo_stream { render turbo_stream: turbo_stream.redirect_to(sessions_path) }
      format.json { head :no_content }
    end
  end
end
