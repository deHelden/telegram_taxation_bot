defmodule TelegramTaxationBot.Taxations.AddIncome do
  alias TelegramTaxationBot.Taxations.ParseCustomTransactionMessage
  alias TelegramTaxationBot.Taxations.Structs.{CreateTaxation, CreateIncomeOutputStruct}
  alias TelegramTaxationBot.Taxations.IncomeSchema
  alias TelegramTaxationBot.Taxations.RenderIncome
  alias TelegramTaxationBot.TelegramContext
  alias TelegramTaxationBot.CurrencyApi
  alias TelegramTaxationBot.Repo

  import Ecto.Changeset

  def call(%CreateTaxation{} = payload) do
    input = payload |> ParseCustomTransactionMessage.call()

    rates = CurrencyApi.get_rates(input.date, input.currency)

    rendered_message =
      %{
        user_id: payload.current_user.id,
        amount: input.amount,
        currency: input.currency,
        date: input.date,
        exchange_rate: rates["rate"],
        target_amount: target_amount(input.amount, Decimal.from_float(rates["rate"]))
      }
      |> create_income_changeset()
      |> Repo.insert!()
      |> RenderIncome.call()

    %CreateIncomeOutputStruct{
      output_message: rendered_message,
      current_user: payload.current_user
    }
    |> TelegramContext.send_message()

    # TODO: pass to TG input_gate
    # TODO:

    # if check parsed exists && validate && get exchange_rates
    # do
    #   save to database
    # else
    #   :parse_error -> parse_error_message
    #   :fetch_exchange_error -> exchange_error_message
  end

  defp create_income_changeset(input) do
    fields = [:user_id, :date, :amount, :exchange_rate, :currency, :target_amount]

    %IncomeSchema{}
    |> cast(input, fields)
    |> validate_required(fields)
  end

  defp target_amount(amount, rate) do
    target = Decimal.mult(amount, rate)

    Decimal.round(target, 2, :half_even)
  end

  # defp error_message do
  #   """
  #   Я не смог распознать твою команду добавления.

  #   Примеры команд, которые точно сработают:

  #   `/add 1000.2 USD 2022-01-01`
  #   """
  # end
end
