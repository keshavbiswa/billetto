require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /index" do
    before do
      5.times do |id|
        Event.create!(id: id, title: "Event #{id}", billetto_id: id, description: "Test Description #{id}", start_date: Time.now)
      end
      get root_path # "/" also will work since this is root path
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'displays event information' do
      event = Event.first
      expect(response.body).to include(event.title)
      expect(response.body).to include(event.start_date.strftime("%B %d, %Y")) # Assuming this is how you format dates in the view
      expect(response.body).to include("Test Description 2")
    end
  end
end
