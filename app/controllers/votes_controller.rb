class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    command = Voting::CreateVoteCommand.new(
      event_id: params[:event_id],
      user_id: current_user["id"],
      vote_flag: params[:direction].to_i == 1
    )

    begin
      command_bus.call(command)
      redirect_to events_path, notice: "Vote recorded!"
    rescue StandardError => e
      redirect_to events_path, alert: e.message
    end
  end

  private

  def command_bus
    Rails.application.config.command_bus
  end
end
