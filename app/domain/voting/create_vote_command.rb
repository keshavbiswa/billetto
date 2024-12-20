module Voting
  class CreateVoteCommand
    attr_reader :event_id, :user_id, :vote_flag

    def initialize(event_id:, user_id:, vote_flag:)
      @event_id = event_id
      @user_id = user_id
      @vote_flag = vote_flag
    end
  end
end
