defmodule TelegramTaxationBot.TelegramContext do
  alias TelegramTaxationBot.Telegram.InputGate
  alias TelegramTaxationBot.Telegram.SendMessage

  def send_message(input) do
    InputGate.coerse_send_message_input(input)
    |> SendMessage.call()
  end
end
