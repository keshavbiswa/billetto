class Event < ApplicationRecord
  validates :title, presence: true
  validates :billetto_id, presence: true
end
