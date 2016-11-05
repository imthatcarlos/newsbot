require "facebook/messenger"

class Brain
  include Facebook::Messenger

  attr_reader :message, :postback
  attr_reader :sender, :text, :attachments

  # message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  # message.sender      # => { 'id' => '1008372609250235' }
  # message.seq         # => 73
  # message.sent_at     # => 2016-04-22 21:30:36 +0200
  # message.text        # => 'Hello, bot!'
  # message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]
  
  def set_message(message)
    @message     = message
    @sender      = message.sender
    @text        = message.text
    @attachments = message.attachments
  end

  def set_postback(postback)
    @postback = postback
    @sender   = postback.sender
  end

  def start_typing
    Facebook::Client.new.set_typing_on(sender["id"])
  end

  def stop_typing
    Facebook::Client.new.set_typing_off(sender["id"])
  end

  def process_message
    if message.messaging["message"]["quick_reply"].present?
      @postback = OpenStruct.new({ payload: message.messaging["message"]["quick_reply"]["payload"] })
      process_postback
    elsif text.present?
      process_text
    else
      send_text("I can't reply :(")
    end
  end

  def process_postback
    resp = Postback.new(postback.payload, user.id).process
    
    resp.each do |r|
      case r[:type]
      when "text"
        send_text(r[:text])
      when "generic"
        send_generic_template(r[:elements])
      when "buttons"
        send_buttons(r[:payload])
      when "quick_replies"
        send_quick_replies(r[:text], r[:replies])
      else
        fail "invalid type"
      end
    end
  end

  def create_log
    if message.present?
      Log.create(
        user_id:       user.id,
        fb_message_id: message.id,
        message_type:  message_type,
        sent_at:       message.sent_at
      )
    else
      Log.create(
        user_id:      user.id,
        message_type: "postback",
        sent_at:      postback.sent_at
      )
    end
  end

  private

  def process_text
    if user.context.state == "subscribing"
      @postback = OpenStruct.new({ payload: text })
      return process_postback
    else
      send_text("Well, hello to you too ;)")
    end
  end

  def send_generic_template(elements)
    Bot.deliver(
      recipient: sender,
      message: {
        attachment: {
          type: "template",
          payload: {
            template_type: "generic",
            elements: elements
          }
        }
      }
    )
  end

  def send_buttons(payload)
    Bot.deliver(
      recipient: sender,
      message: {
        attachment: {
          type: "template",
          payload: payload
        }
      }
    )
  end

  def send_text(text)
    Bot.deliver(
      recipient: sender,
      message: {
        text: text
      }
    )
  end

  def send_quick_replies(text, replies)
    Bot.deliver(
      recipient: sender,
      message: {
        text: text,
        quick_replies: replies
      }
    )
  end

  def send_error
    Bot.deliver(
      recipient: sender,
      message: {
        text: "Sorry, didn't understand that."
      }
    )
  end

  def message_type
    text.present? ? "text" : attachments.first["type"]
  end

  def user
    @user ||= set_user
  end

  def set_user
    @user = User.find_by(fb_id: sender["id"])
    
    if @user.nil?
      fb_user = Facebook::Client.new.get_user(sender["id"])
      @user = User.create(
        fb_id:     sender["id"],
        full_name: fb_user["first_name"] + " " + fb_user["last_name"],
        gender:    fb_user["gender"],
        locale:    fb_user["locale"],
        timezone:  fb_user["timezone"]
      )
    end

    @user
  end

  # 
  def set_get_started_btn
    #curl -X POST -H "Content-Type: application/json" -d '{"setting_type": "call_to_actions", "thread_state": "new_thread", "call_to_actions": [{"payload": "Hey there! We are a coffee shop." }] }' "https://graph.facebook.com/v2.6/me/thread_settings?access_token=EAAIhGQtDHJ8BALjzLfTbXGZCdN8FKry6ORX4QZB9DG3ZADMOJHyYOMJQcvNMPQFEiqFVFrHKKCDWATpe4ZChFZCpBYJuVoZAiRs4r597zdGLeLQeBDkbkdQImcJPqOHfeIl40cbOG0q56Kjq7unBY0lUT8vqFYvXF1WaOXR3zqKAZDZD"
  end
end