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
    # if check parsed exists && validate && get exchange_rates
    # do
    #   save to database
    # else
    #   :parse_error -> parse_error_message
    #   :fetch_exchange_error -> exchange_error_message
    # TODO: pass to TG input_gate

    user = payload.current_user
    parse_input = payload |> ParseCustomTransactionMessage.call()

    # TODO: rewrite with monades
    if parse_input do
      validate_date = validate_date_boarder(parse_input.date)

      if validate_date do
        fetch_rates = CurrencyApi.get_rates(parse_input.date, parse_input.currency)

        if fetch_rates do
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
          make_fetch_currency_error_message(parse_input.currency)
          |> render_message(user)
        end
      else
        make_date_validation_error_message() |> render_message(user)
      end
    else
      make_parse_error_message() |> render_message(user)
    end
  end

  def validate_date_boarder(date) do
    parsed_date_in_past =
      Date.compare(
        Date.utc_today(),
        date |> Date.from_iso8601!()
      ) == :gt

    if parsed_date_in_past, do: true, else: false
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

  def make_parse_error_message do
    ~s(
      Извини , не могу понять этот формат.
      \r\nпопробуй так:
      /add 1000 EUR 2022-02-01
    )
  end

  def make_date_validation_error_message do
    ~s(
      Извини, я еще не научился управлять будущими поступлениями.
      \r\nПопробуй использовать меня для подсчета уже полученных средств.
    )
  end

  def make_fetch_currency_error_message(currency) do
    ~s(
      Извини, я не смог скачать курсы обмена для #{currency}
    )
  end

  def render_message(message, user) do
    %CreateIncomeOutputStruct{
      output_message: message,
      current_user: user
    }
    |> TelegramContext.send_message()
  end

  # defp error_message do
  #   """
  #   Я не смог распознать твою команду добавления.

  #   Примеры команд, которые точно сработают:

  #   `/add 1000.2 USD 2022-01-01`
  #   """
  # end
end
