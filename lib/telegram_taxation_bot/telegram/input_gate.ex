defmodule TelegramTaxationBot.Telegram.InputGate do
  alias TelegramTaxationBot.Telegram.Structs.SendMessageStruct
  alias TelegramTaxationBot.Taxations.Structs.CreateIncomeOutputStruct

  def coerse_send_message_input(%CreateIncomeOutputStruct{} = input) do
    %SendMessageStruct{
      message: input.output_message,
      chat_id: input.current_user.telegram_chat_id
    }
  end
end
