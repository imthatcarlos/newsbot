require "facebook/messenger"

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe

Bot.on :message do |message|

  brain = Brain.new
  brain.set_message(message)
  brain.start_typing
  brain.create_log
  brain.process_message

end

Bot.on :postback do |postback|

  brain = Brain.new
  brain.set_postback(postback)
  brain.start_typing
  brain.create_log
  brain.process_postback

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