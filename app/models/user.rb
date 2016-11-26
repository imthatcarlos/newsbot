class User < ActiveRecord::Base
  validates_presence_of :fb_id, :full_name

  has_many :story_subscriptions
  has_many :contexts

  def first_name
    full_name.split(" ").first
  end

  def subscribed_to?(source_id)
    story_subscriptions.where(source_id: source_id).present?
  end

  def context
    contexts.last
  end
end