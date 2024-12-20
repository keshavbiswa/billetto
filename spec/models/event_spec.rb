require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "Validations" do
    it "requires title" do
      event = Event.new(start_date: Time.now, billetto_id: 123)
      expect(event).not_to be_valid
      event.title = "Test Event"
      expect(event).to be_valid
    end

    it "requires billetto_id" do
      event = Event.new(start_date: Time.now, title: 'Test Event')
      expect(event).not_to be_valid
      event.billetto_id = 123
      expect(event).to be_valid
    end
  end
end
