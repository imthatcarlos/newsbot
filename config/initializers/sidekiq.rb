redis_url = ENV["REDIS_URL"] || "redis://localhost:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.average_scheduled_poll_interval = 3
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end