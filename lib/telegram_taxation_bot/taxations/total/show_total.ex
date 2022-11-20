defmodule TelegramTaxationBot.Taxations.Total.ShowTotal do
  import Ecto.Query
  alias TelegramTaxationBot.Repo

  alias TelegramTaxationBot.TelegramContext
  alias TelegramTaxationBot.Taxations.Income.IncomeSchema
  alias TelegramTaxationBot.Taxations.Total.{ParseTotalMessage, RenderTotal, CalculateTotal}

  alias TelegramTaxationBot.Taxations.Structs.{
    CreateTaxation,
    CreateIncomeOutputStruct
  }

  def call(%CreateTaxation{} = payload) do
    user = payload.current_user

    # TODO: check if input can't be parsed with tuples
    payload
    |> ParseTotalMessage.call()
    |> CalculateTotal.call(user)
    |> RenderTotal.call()
    |> render_message(user)
  end

  defp render_message(message, user) do
    %CreateIncomeOutputStruct{
      output_message: message,
      current_user: user
    }
    |> TelegramContext.send_message()
  end
end
