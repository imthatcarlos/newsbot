module Elements
  class StoryCarousel
    attr_reader :type, 
                :query,
                :stories

    def initialize(type, query = nil)
      @type  = type
      @query = query
    end

    def elements
      set_stories
      @stories.map { |story| Elements::StoryElement.new(story.id).element }
    end

    private

    def set_stories
      case type
      when "top"
        @stories = Story.top_today
      when "for_you"
        @stories = user.preferred_stories
      else # search
        @stories = Story.today.search(@query)
      end
    end

  end
end