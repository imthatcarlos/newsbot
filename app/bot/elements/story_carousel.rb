module Elements
  class StoryCarousel
    attr_reader :source

    def initialize(source_id)
      @source = Source.find(source_id).api_id
    end

    def elements
      stories.map { |story| Elements::StoryElement.new(story).element }
    end

    private

    def stories
      NewsAPI::Client.new(source).top_headlines.select { |s| s["description"].present? }
    end
  end
end