defmodule TelegramTaxationBot.MessageData do
  defstruct [:message, :chat_id, :name, :current_user, :reply_to_message]
end
