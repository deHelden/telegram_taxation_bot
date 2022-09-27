defmodule TelegramTaxationBot.Taxations.InputGate do
  alias TelegramTaxationBot.Taxations.Structs.CreateTaxation
  alias TelegramTaxationBot.MessageData
  # course output to what we actually need for users

  def coerse_create_income_input(%MessageData{} = input) do
    %CreateTaxation{
      message: input.message,
      user_id: input.current_user.id
    }
  end

  # def coerse_create_income_output(%IncomesData{} = output) do
  #   %{
  #     date: output.date,
  #     amount: output.amount,
  #     currency: output.currency,
  #     exchange_rate: output.exchange_rate,
  #     target_amount: output.target_amount
  #   }
  # end
end
