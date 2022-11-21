defmodule TelegramTaxationBot.Taxations.Total.CalculateTotal do
  import Ecto.Query
  alias TelegramTaxationBot.Repo

  alias TelegramTaxationBot.Taxations.Income.IncomeSchema

  def call({:ok, parsed_input}, user) do
    user_id = user.id

    all_incomes =
      user_id
      |> get_all_incomes(parsed_input.date)
      |> transform_incomes()

    total_income =
      user_id
      |> get_total_income_to_month(parsed_input.date)
      |> Decimal.to_string()

    month_income = user_id |> get_month_income(parsed_input.date)

    {
      :ok,
      %{
        all_incomes: all_incomes,
        total_income: total_income,
        month_income: month_income,
        one_percent_tax: get_month_tax2pay_amount(month_income)
      }
    }
  end

  def call({:error, :invalid_date}, _) do
    {:error, :invalid_date}
  end

  def get_total_income_to_month(user_id, date) do
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
    unless month_income do
      "No income this month"
    else
      Decimal.mult(month_income, Decimal.from_float(0.01)) |> Decimal.round(2, :half_even)
    end
  end

  def get_all_incomes(user_id, date) do
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

  defp transform_incomes(incomes) do
    Enum.map(incomes, fn [e1, e2, e3, e4] -> [Decimal.to_string(e1) <> " " <> e2, e3, e4] end)
  end
end
