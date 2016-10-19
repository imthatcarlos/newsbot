module Elements
  class MenuElement

    def initialize
    end

    def payload
      {
        template_type: "button",
        text: "",
        buttons: [
          {
            type:    "postback",
            text:    "Top Stories",
            payload: "top_stories"
          },
          {
            type:    "postback",
            text:    "Stories for you",
            payload: "for_you",
          },
          {
            type:    "postback",
            text:    "Ask NewsBot",
            payload: "ask"
          }
        ]
      }
    end
  end
end