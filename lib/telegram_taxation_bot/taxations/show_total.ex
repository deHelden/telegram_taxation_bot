defmodule TelegramTaxationBot.Taxations.ShowTotal do
  import Ecto.Query
  alias TelegramTaxationBot.Repo

  alias TelegramTaxationBot.TelegramContext
  alias TelegramTaxationBot.Taxations.IncomeSchema
  alias TelegramTaxationBot.Taxations.ParseTotalMessage

  alias TelegramTaxationBot.Taxations.Structs.{
    CreateTaxation,
    CreateIncomeOutputStruct
  }

  def call(%CreateTaxation{} = payload) do
    user = payload.current_user
    user_id = user.id

    parsed_input = payload |> ParseTotalMessage.call()

    if parsed_input do
      # may run this async

      total_income =
        user_id
        |> get_total_income_to_month(parsed_input.date)
        |> Decimal.to_string()

      month_income = user_id |> get_month_income(parsed_input.date)
      # all_incomes is a table may be moved to /stats
      all_incomes = user_id |> get_all_incomes(parsed_input.date) |> render_table()

      rendered_message = ~s(
        #{all_incomes}

        Total Taxation Amount : #{total_income}
        \r\nAmount in month '#{parsed_input.date}': #{month_income}
        \r\n1% tax to pay: #{get_month_tax2pay_amount(month_income)}
        )

      rendered_message
      |> render_message(user)
    else
      "не могу распознать дату" |> render_message(user)
    end
  end

  defp get_total_income_to_month(user_id, date) do
    to_date = Date.from_iso8601!(date) |> Date.end_of_month()

    IncomeSchema
    |> where([i], i.user_id == ^user_id and i.date <= ^to_date)
    |> select([i], sum(i.target_amount))
    |> Repo.one()
  end

  def get_month_income(user_id, date) do
    from_date = Date.from_iso8601!(date) |> Date.beginning_of_month()
    to_date = Date.from_iso8601!(date) |> Date.end_of_month()

    IncomeSchema
    |> where([i], i.user_id == ^user_id and i.date >= ^from_date and i.date <= ^to_date)
    |> select([i], sum(i.target_amount))
    |> Repo.one()
  end

  def get_month_tax2pay_amount(month_income) do
    Decimal.mult(month_income, Decimal.from_float(0.01)) |> Decimal.round(2, :half_even)
  end

  defp get_all_incomes(user_id, date) do
    to_date = Date.from_iso8601!(date) |> Date.end_of_month()

    IncomeSchema
    |> where([i], i.user_id == ^user_id and i.date <= ^to_date)
    |> order_by([i], asc: i.date)
    |> select([i], [i.amount, i.currency, i.date, i.target_amount])
    |> Repo.all()

    # [
    #   [#Decimal<6200>, "USD", ~D[2022-10-01]],
    #   [#Decimal<5000>, "EUR", ~D[2022-09-29]]
    # ]
  end

  defp render_table(incomes) do
    title = "Incomes this month"
    header = ["Amount", "Currency", "Date", "Converted"]

    TableRex.quick_render!(incomes, header, title)
  end

  defp render_message(message, user) do
    %CreateIncomeOutputStruct{
      output_message: message,
      current_user: user
    }
    |> TelegramContext.send_message()
  end
end
