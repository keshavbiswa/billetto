class BillettoAPI
  include HTTParty
  base_uri "https://billetto.dk/api/v3"

  def initialize(api_key = Rails.application.credentials.billetto.dig(:access_key_id), api_secret = Rails.application.credentials.billetto.dig(:access_key_secret))
    @api_key = api_key
    @api_secret = api_secret
    @api_keypair = "#{api_key}:#{api_secret}"
  end

  def get_public_events(page: 1, limit: 20)
    response = self.class.get("/public/events", query: { page: page, limit: limit }, headers: headers)
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      # Logging the error and raising an exception
      error_message = response.parsed_response.dig("error", "message") || response.message
      error_type = response.parsed_response.dig("error", "type") || "api_error"

      Rails.logger.error "Billetto API Error: #{response.code} - #{error_message}"
      puts "response: #{response}"
      raise StandardError, "Billetto API Error: #{error_message}"
    end
  end

  def headers
    @headers ||= {
      "Accept": "application/json",
      "Api-Keypair": @api_keypair
    }
  end
end
