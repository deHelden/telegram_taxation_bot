defmodule TelegramTaxationBot.Taxations.InputGate do
  alias TelegramTaxationBot.Taxations.Structs.CreateTaxation
  alias TelegramTaxationBot.MessageData
  # course output to what we actually need for users

  def coerse_create_income_input(%MessageData{} = input) do
    %CreateTaxation{
      message: input.message,
      current_user: input.current_user
    }
  end
end
