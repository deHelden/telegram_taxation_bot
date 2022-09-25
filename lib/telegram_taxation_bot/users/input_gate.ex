defmodule TelegramTaxationBot.Users.InputGate do
  alias TelegramTaxationBot.MessageData
  # course input to what we actually need for users
  def coerse_create_user_input(%MessageData{} = input) do
    %{
      name: input.name,
      telegram_chat_id: input.chat_id
    }
  end
end
