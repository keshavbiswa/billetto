class Event < ApplicationRecord
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validates :billetto_id, presence: true


  def total_votes
    upvotes_count - downvotes_count
  end
end
