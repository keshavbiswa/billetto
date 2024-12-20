class Vote < ApplicationRecord
  belongs_to :event

  validates :user_id, presence: true
  validates :vote_flag, inclusion: [ true, false ]
  validates :user_id, uniqueness: { scope: :event_id, message: "has already voted on this event" }

  counter_culture :event,
                  column_name: proc { |model| model.vote_flag? ? "upvotes_count" : "downvotes_count" },
                  column_names: { "votes.vote_flag = true" => "upvotes_count", "votes.vote_flag = false" => "downvotes_count" }
end
