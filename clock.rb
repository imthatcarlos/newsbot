require "sidekiq"

include Clockwork

# ------------------------------------------------------------------------------
# NOTE: All times at in 24-hour format!
# ------------------------------------------------------------------------------

# Default timezone to use
timezone = "America/Chicago"

# Send monday morning notifications
every 1.day, "job.subscriptions.morning", at: "09:00", tz: timezone do
  Sidekiq::Client.push("class" => "SubscriptionWorker", "args" => ["morning"])
end

every 1.day, "job.subscriptions.noon", at: "23:24", tz: timezone do
  Sidekiq::Client.push("class" => "SubscriptionWorker", "args" => ["noon"])
end

every 1.day, "job.subscriptions.evening", at: "17:00", tz: timezone do
  Sidekiq::Client.push("class" => "SubscriptionWorker", "args" => ["evening"])
end

