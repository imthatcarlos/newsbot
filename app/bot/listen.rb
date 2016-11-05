require "facebook/messenger"

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe

Bot.on :message do |message|

  brain = Brain.new
  brain.set_message(message)
  brain.start_typing
  brain.create_log
  brain.process_message
  brain.stop_typing

end

Bot.on :postback do |postback|

  brain = Brain.new
  brain.set_postback(postback)
  brain.start_typing
  brain.create_log
  brain.process_postback
  brain.stop_typing

end

# Postback for user pressing 'Get Started' button
Facebook::Messenger::Thread.set(
  setting_type: "call_to_actions",
  thread_state: "new_thread",
  call_to_actions: [
    {
      payload: "new_thread"
    }
  ]
)

# Persistent menu
Facebook::Messenger::Thread.set(
  setting_type: "call_to_actions",
  thread_state: "existing_thread",
  call_to_actions: [
    {
      type: "postback",
      title: "View Publications",
      payload: "publications"
    },
    {
      type: "postback",
      title: "My Subscriptions",
      payload: "subscriptions"
    },
    {
      type: "web_url",
      title: "Powered by News API",
      url: "http://newsapi.org"
    }
  ]
)