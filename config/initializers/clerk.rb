Clerk.configure do |config|
  config.api_key = ENV["CLERK_SECRET_KEY"]
  config.logger = Logger.new(STDOUT)
  config.middleware_cache_store = Rails.cache
  config.base_url="https://api.clerk.dev/v1/"
end
