require 'rails_helper'

RSpec.describe EventIngestionService, type: :service do
  let(:billetto_api) { double('BillettoAPI') }
  subject { described_class.new(billetto_api) }

  describe '#ingest_events' do
    context 'when the API call is successful' do
      let(:event_data) do
        { 'object': 'list',
          'data': [
            {
              "id": "1",
              "object": "public_event",
              "kind": "regular",
              "state": "published",
              "title": "Event 1",
              "description": "Test Description 1",
              "url": "https://test-url.com",
              "image_link": "https://test-image-url.com",
              "availability": true,
              "startdate": "2025-01-16T10:30:00Z",
              "enddate": "2025-01-16T11:15:00Z"
            },
            {
              "id": "2",
              "object": "public_event",
              "kind": "regular",
              "state": "published",
              "title": "Event 2",
              "description": "Test Description 2",
              "url": "https://test-url.com",
              "image_link": "https://test-image-url.com",
              "availability": true,
              "startdate": "2025-01-16T10:30:00Z",
              "enddate": "2025-01-16T11:15:00Z" }
          ] }
      end

      before do
        allow(billetto_api).to receive(:get_public_events).with(page: 1, limit: 20).and_return(event_data)
      end

      it 'creates or updates events' do
        expect { subject.ingest_events }.to change { Event.count }.by(2)

        event1 = Event.find_by(billetto_id: '1')
        expect(event1.title).to eq('Event 1')
        expect(event1.start_date).to eq(Time.parse('2025-01-16T10:30:00Z'))
        expect(event1.description).to eq('Test Description 1')
        expect(event1.image_link).to eq('https://test-image-url.com')

        event2 = Event.find_by(billetto_id: '2')
        expect(event2.title).to eq('Event 2')
        expect(event2.start_date).to eq(Time.parse('2025-01-16T10:30:00Z'))
        expect(event2.description).to eq('Test Description 2')
        expect(event2.image_link).to eq('https://test-image-url.com')
      end
    end
  end
end
