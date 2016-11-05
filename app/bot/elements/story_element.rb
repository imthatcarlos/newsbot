module Elements
  class StoryElement
    attr_reader :story, :user_id

    def initialize(story)
      @story = Story.new(
        title:     story["title"],
        subtitle:  story["description"],
        image_url: story["urlToImage"],
        url:       story["url"]
      )
    end

    def element
      if story.summary.present?
        with_summary
      else
        without_summary
      end
    end

    private

    def with_summary
      {
        title:     story.title,
        image_url: story.image_url,
        subtitle:  story.subtitle,
        buttons: [
          {
            type:  "web_url",
            url:   story.url,
            title: "Read Article",
            webview_height_ratio: "full"
          },
          {
            type:    "postback",
            title:   "Get Summary",
            payload: "get_summary=#{@story.id}"
          },
          {
            type: "element_share"
          }
        ]
      }
    end

    def without_summary
      {
        title:     story.title,
        image_url: story.image_url,
        subtitle:  story.subtitle,
        buttons: [
          {
            type:  "web_url",
            url:   story.url,
            title: "Read Article",
            webview_height_ratio: "full"
          },
          {
            type: "element_share"
          }
        ]
      }
    end
  end
end