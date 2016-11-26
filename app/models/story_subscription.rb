class StorySubscription < ActiveRecord::Base
  validates :user_id, 
            :source_id,
            :scheduled_time,
            presence: true

  belongs_to :user
  belongs_to :source
end