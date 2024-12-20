namespace :events do
  desc "Ingest events from Billetto API"
  task :ingest, [ :start_page, :end_page, :limit ] => :environment do |t, args|
    start_page = args[:start_page] ? args[:start_page].to_i : 1
    end_page = args[:end_page] ? args[:end_page].to_i : 1
    limit = args[:limit] ? args[:limit].to_i : 20

    puts "Starting event ingestion (pages: #{start_page} to #{end_page}, limit: #{limit})..."
    ingestion_service = EventIngestionService.new(BillettoAPI.new)

    (start_page..end_page).each do |page|
      puts "Processing page #{page}..."
      ingestion_service.ingest_events(page: page, limit: limit)
      puts "Page #{page} processed."
    end

    puts "Finished event ingestion."
  end
end
