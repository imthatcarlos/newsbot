class SendStoriesWorker < BaseWorker
  def perform(user_id, source_id)
    Brain.new.send_subscription_stories(user_id, source_id)
  end
end