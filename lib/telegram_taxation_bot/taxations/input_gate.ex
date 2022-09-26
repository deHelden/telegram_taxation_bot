defmodule TelegramTaxationBot.Taxations.InputGate do
  alias TelegramTaxationBot.Taxations.Structs.CreateTaxation
  alias TelegramTaxationBot.UsersContext
  alias TelegramTaxationBot.MessageData
  # course output to what we actually need for users

  def coerse_create_income_input(%MessageData{} = input) do
    user_id = UsersContext.get_user_by_chat_id(input.chat_id).id

    %CreateTaxation{
      message: input.message,
      user_id: user_id
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
