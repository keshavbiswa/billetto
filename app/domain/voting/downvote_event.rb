module Voting
  class DownvoteEvent
    def call(event_id, user_id)
     event_store.publish(
       EventDownvoted.new(data: {
         event_id: event_id,
         user_id: user_id
       }),
       stream_name: "Event$#{event_id}"
     )
    end

    private

    def event_store
      Rails.configuration.event_store
    end
  end
end
