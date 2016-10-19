class User < ActiveRecord::Base
  validates_presence_of :fb_id, :full_name

  def first_name
    full_name.split(" ").first
  end

  # Some algorithm to determine which stories this user would like
  def preferred_stories
    stories = []
    
    if story_preference1.present?
      stories += Story.today.of_category(story_preference1)
    end

    if story_preference2.present?
      stories += Story.today.of_category(story_preference2)
    end

    if story_preference3.present?
      stories += Story.today.of_category(story_preference3)
    end

    stories.map { |story| story.element }
  end
end