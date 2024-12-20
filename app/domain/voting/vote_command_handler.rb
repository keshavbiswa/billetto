module Voting
  class VoteCommandHandler
    def call(command)
      event = Event.find(command.event_id)
      vote = event.votes.find_or_initialize_by(user_id: command.user_id)
      vote.vote_flag = command.vote_flag

      begin
        is_new_record = vote.new_record?
        vote.save!

        if is_new_record
          if command.vote_flag
            Voting::UpvoteEvent.new.call(event.id, command.user_id)
          else
            Voting::DownvoteEvent.new.call(event.id, command.user_id)
          end
        else
          raise "You have already voted on this event."
        end

      rescue ActiveRecord::RecordNotUnique
        raise "You have already voted on this event."

      rescue ActiveRecord::RecordInvalid => e
        raise "Unable to vote: #{e.record.errors.full_messages.join(', ')}"
      end
    end
  end
end
