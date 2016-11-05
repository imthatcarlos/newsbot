module Elements
  class SourceCarousel

    attr_reader :user

    def initialize(user_id)
      @user = User.find(user_id)
    end

    def elements(page = 1)
      sources  = Source.all.paginate(page: page, per_page: 9)
      elements = sources.map { |s| element(s) }
      
      if sources.total_pages != sources.current_page
        elements += last("publications&page=#{page + 1}") 
      end

      elements
    end

    def subscriptions(page = 1)
      subscriptions = user.story_subscriptions.paginate(page: page, per_page: 9)
      elements = subscriptions.map { |s| element(s.source) }
      
      if subscriptions.total_pages != subscriptions.current_page
        elements += last("subscriptions&page=#{page + 1}")
      end

      elements
    end

    private

    def last(payload)
      [
        {
          title:     "View More",
          image_url: "",
          subtitle:  "",
          buttons: [
            {
              type:    "postback",
              title:   "More",
              payload: payload
            }
          ]
        }
      ]
    end

    def element(source)
      skel = skeleton(source)
      skel[:buttons] << tail(source.id)
      skel      
    end

    def skeleton(source)
      {
        title:     source.name,
        image_url: source.image_url,
        subtitle:  "",
        buttons: [
          {
            type:    "postback",
            title:   "Top Stories",
            payload: "top_stories&source_id=#{source.id}"
          }
        ]
      }
    end

    def tail(source_id)
      if user.subscribed_to?(source_id)
        {
          type:    "postback",
          title:   "Unsubscribe",
          payload: "unsubscribe&source_id=#{source_id}"
        }
      else
        {
          type:    "postback",
          title:   "Subscribe",
          payload: "subscribe&source_id=#{source_id}"
        }
      end
    end

  end
end