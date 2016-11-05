class Postback
  attr_reader :payload, :user

  def initialize(payload, user_id)
    @payload = payload
    @user = User.find(user_id)
  end

  def process

    case payload
    when "new_thread"
      send_onboard
    when /top_stories&source_id=(\d+)/
      send_top_stories($1.to_i)
    when /^subscribe&source_id=(\d+)/
      ask_for_schedule($1.to_i)
    when /^subscribe&schedule=(\w+)/
      subscribe($1)
    when /^unsubscribe&source_id=(\d+)/
      unsubscribe($1.to_i)
    when "publications"
      publications
    when /publications&page=(\d+)/
      publications($1.to_i)
    when "subscriptions"
      subscriptions
    when /subscriptions&page=(\d+)/
      subscriptions($1.to_i)
    else
      send_sorry
    end
  end

  private

  def send_onboard
    user.contexts.create(state: "onboarding")

    onboard = [
      {
        type: "text",
        text: "Hey there #{user.first_name}. I’ll send you top stories from your favorite publications. You can view all sources at any time from the menu. You can also subscribe to a publication and receive top stories daily at a scheduled time."
      },
      {
        type: "text",
        text: "Here's the list of publications I have available."
      }
    ] 

    onboard + publications
  end

  def publications(page = 1)
    [
      {
        type: "generic",
        elements: Elements::SourceCarousel.new(user.id).elements(page)
      }
    ]
  end

  def subscriptions(page = 1)
    if user.story_subscriptions.any?
      [
        {
          type: "text",
          text: "These are your subscriptions."
        },
        {
          type: "generic",
          elements: Elements::SourceCarousel.new(user.id).subscriptions(page)
        },
        {
          type: "quick_replies",
          text: " ",
          replies: [
            {
              content_type: "text",
              title: "All Publications",
              payload: "publications"
            }
          ]
        }
      ]
    else
      msg = [
        {
          type: "text",
          text: "Looks like you don't have any subscriptions yet. Subscribe to your favorite publications!"
        }
      ]

      msg + publications
    end
  end

  def send_top_stories(source_id)
    resp = [
      {
        type: "text",
        text: "Here are the top stories for #{Source.find(source_id).name}"
      },
      {
        type: "generic",
        elements: Elements::StoryCarousel.new(source_id).elements.first(10)
      }
    ]

    resp + menu_options
  end

  def ask_for_schedule(source_id)
    user.contexts.create(state: "subscribing", param: source_id)
    [
      {
        type: "quick_replies",
        text: "When would you like to receive updates for #{Source.find(source_id).name}?",
        replies: [
          {
            content_type: "text",
            title: "Morning",
            payload: "subscribe&schedule=morning"
          },
          {
            content_type: "text",
            title: "Noon",
            payload: "subscribe&schedule=noon"
          }, 
          {
            content_type: "text",
            title: "Evening",
            payload: "subscribe&schedule=evening"
          }
        ]
      }
    ]
  end

  def subscribe(schedule)
    time = nil
    
    case schedule
    when "morning"
      time = Time.now.beginning_of_day + 9.hours
    when "noon"
      time = Time.now.beginning_of_day + 12.hours
    when "evening"
      time = Time.now.beginning_of_day + 17.hours
    end

    source_id = user.contexts.state("subscribing").last.param
    user.story_subscriptions.create(source_id: source_id, scheduled_time: time)
    send_subscription_confirmation(source_id, time)
  end

  def unsubscribe(source_id)
    StorySubscription.where(user_id: user.id, source_id: source_id).delete
    items = [
      {
        type: "text",
        text: "Done."
      }
    ]

    items + menu_options
  end

  def send_subscription_confirmation(source_id, time)
    user.contexts.create(state: "just_subscribed", param: source_id)
    resp = [
      {
        type: "text",
        text: "Great. You'll get top stories from #{Source.find(source_id).name} daily at #{time.strftime("%l%p")}."
      }
    ]

    resp + menu_options
  end

  def menu_options
    [
      {
        type: "quick_replies",
        text: " ",
        replies: [
          {
            content_type: "text",
            title: "My Subscriptions",
            payload: "subscriptions"
          },
          {
            content_type: "text",
            title: "View Publications",
            payload: "publications"
          }
        ]
      }
    ]
  end

  def send_sorry
    msg = [
      {
        type: "text",
        text: "Sorry, not sure what you're trying to say."
      },
      {
        type: "text",
        text: "Here's the list of publications I have available."
      }
    ]

    msg + publications
  end
end