module Elements
  class StoryElement
    attr_reader :story, :user_id

    def initialize(story_id, user_id)
      @story    = Story.find(story_id)
      @user_id  =  user_id 
    end

    def element
      if summary.present?
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
            title: "Read Full Article",
            webview_height_ratio: "full"
          },
          {
            type:    "postback",
            title:   "Get Summary",
            payload: "get_summary=#{@story.id}"
          },
          {
            type:    "postback",
            title:   "Ask NewsBot",
            payload: "ask"
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
            title: "Read Full Article",
            webview_height_ratio: "full"
          },
          {
            type:    "postback",
            title:   "Stories For You",
            payload: "for_you"
          },
          {
            type:    "postback",
            title:   "Ask NewsBot",
            payload: "ask"
          }
        ]
      }
    end
  end
end