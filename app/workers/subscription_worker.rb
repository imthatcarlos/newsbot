class SubscriptionWorker < BaseWorker
  def perform(schedule)
    StorySubscription.where(scheduled_time: schedule).each do |s|
      SendStoriesWorker.perform_async(s.user_id, s.source_id)
    end
  end
end