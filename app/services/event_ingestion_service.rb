class EventIngestionService
  def initialize(billetto_api = BillettoAPI)
    @billetto_api = billetto_api
  end

  def ingest_events(page: 1, limit: 20)
    begin
      event_data = @billetto_api.get_public_events(page: page, limit: limit)
      event_data[:data].each do |event_json|
        create_or_update_event(event_json)
      end
    rescue StandardError => e
      Rails.logger.error "Event Ingestion Error: #{e.message}"
    end
  end

  private

  def create_or_update_event(event_json)
    event = Event.find_or_initialize_by(billetto_id: event_json[:id])
    event.title = event_json[:title]
    event.start_date = event_json[:startdate]
    event.end_date = event_json[:enddate]
    event.description = event_json[:description].present? ? event_json[:description][0..250] : ""
    event.image_link = event_json[:image_link]
    event.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to save event: #{event.billetto_id}, Error: #{e.message}"
  end
end
