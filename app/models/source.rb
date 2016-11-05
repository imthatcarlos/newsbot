class Source < ActiveRecord::Base
  has_many :story_subscriptions
end