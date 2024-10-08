defmodule TelegramTaxationBot.Taxations.Income.AddIncome do
  alias TelegramTaxationBot.Taxations.Income.{
    IncomeSchema,
    RenderIncome,
    ParseCustomTransactionMessage
  }

  alias TelegramTaxationBot.Taxations.Structs.{CreateTaxation, CreateIncomeOutputStruct}
  alias TelegramTaxationBot.TelegramContext
  alias TelegramTaxationBot.CurrencyApi
  alias TelegramTaxationBot.Repo

  import Ecto.Changeset

  def call(%CreateTaxation{} = payload) do
    user = payload.current_user

    with(
      {:parsed, parse_input} <- payload |> ParseCustomTransactionMessage.call(),
      {:rate_fetch_success, fetch_rates} <-
        CurrencyApi.get_rates(parse_input.date, parse_input.currency),
      {:valid_date, true} <- validate_date_boarder(parse_input.date)
    ) do
      %{
        user_id: user.id,
        amount: parse_input.amount,
        currency: parse_input.currency,
        date: parse_input.date,
        exchange_rate: fetch_rates["rate"],
        target_amount:
          target_amount(
            parse_input.amount,
            Decimal.from_float(fetch_rates["rate"])
          )
      }
      |> create_income_changeset()
      |> Repo.insert!()
      |> RenderIncome.call()
      |> render_message(user)
    else
      {:error, :parse_error} ->
        make_parse_error_message() |> render_message(user)

      {:fetch_rates_error, nil} ->
        {:error, make_fetch_currency_error_message() |> render_message(user)}

      {:invalid_date, false} ->
        make_date_validation_error_message() |> render_message(user)
    end
  end

  defp validate_date_boarder(date) do
    parsed_date_in_past = Date.compare(Date.utc_today(), date |> Date.from_iso8601!())

    not_future_date_validated = parsed_date_in_past == :gt || parsed_date_in_past == :eq

    if not_future_date_validated, do: {:valid_date, true}, else: {:invalid_date, false}
  end

  defp create_income_changeset(input) do
    fields = [:user_id, :date, :amount, :exchange_rate, :currency, :target_amount]

    %IncomeSchema{}
    |> cast(input, fields)
    |> validate_required(fields)
  end

  defp target_amount(amount, rate) do
    Decimal.mult(amount, rate) |> Decimal.round(2, :half_even)
  end

  defp make_parse_error_message do
    ~s(
      Извини , не могу понять этот формат.
      \r\nпопробуй так:
      /add 1000 EUR 2022-02-01
    )
  end

  defp make_date_validation_error_message do
    ~s(
      Извини, я еще не научился управлять будущими поступлениями.
      \r\nПопробуй использовать меня для подсчета уже полученных средств.
    )
  end

  defp make_fetch_currency_error_message do
    ~s(
      Извини, я не смог скачать курсы обмена для указанной валюты.
    )
  end

  defp render_message(message, user) do
    %CreateIncomeOutputStruct{
      output_message: message,
      current_user: user
    }
    |> TelegramContext.send_message()
  end
end
