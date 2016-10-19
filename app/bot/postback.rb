class Postback
  attr_reader :payload, :user

  def initialize(payload, user_id)
    @payload = payload
    @user    = User.find(user_id)
  end

  def process
    case payload
    when "new_thread"
      send_onboard
    when "for_you"
      send_preferred
    when "top_stories"
      send_top_stories
    when "ask"
      send_hint
    end
  end

  private

  def send_onboard
    [
      {
        type: "text",
        text: "Hi there, let’s get started. I’ll send you top stories every day. If you get lost, just type help. Or, use a few words to tell me what you want to know more about. For example, you could type 'headlines', 'Rio Olympics' or 'politics.'"
      },
      {
        type: "buttons",
        payload: Elements::MenuElement.new(@user.id).payload
      }
    ]
  end

  def send_hint
    [
      {
        type: "text",
        text: "What’re you looking for? Use one or two  words to tell me what you want to know more about. For example, you could type 'politics' or 'space.'"
      }
    ]
  end

  def send_preferred
    [
      {
        type: "generic",
        elements: Elements::StoryCarousel.new("for_you").elements
      }
    ]
  end

  def send_top_stories
    [
      {
        type: "generic",
        elements: Elements::StoryCarousel.new("top").elements
      }
    ]
  end
end