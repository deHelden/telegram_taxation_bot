defmodule TelegramTaxationBot.Telegram.SendMessage do
  alias TelegramTaxationBot.Telegram.Structs.SendMessageStruct

  def call(%SendMessageStruct{} = input) do
    Nadia.send_message(input.chat_id, input.message, parse_mode: "Markdown")
  end
end
