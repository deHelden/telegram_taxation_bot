defmodule TelegramTaxationBot.Taxations.ShowTotal do
  import Ecto.Query
  alias TelegramTaxationBot.Repo

  alias TelegramTaxationBot.TelegramContext
  alias TelegramTaxationBot.Taxations.IncomeSchema

  alias TelegramTaxationBot.Taxations.Structs.{
    ShowTotalTaxation,
    CreateIncomeOutputStruct
  }

  def call(%ShowTotalTaxation{} = payload) do
    user_id = payload.current_user.id

    # may run this async
    total_income = user_id |> get_total_income_by_user() |> Decimal.to_string()
    # TODO: sum all incomes that have affected current month
    last_month_income = user_id |> get_last_month_income() |> Decimal.to_string()
    # current_month_incomes is a table may be moved to /stats
    current_month_incomes = user_id |> get_last_month_incomes() |> render_table()

    rendered_message = ~s(
      #{current_month_incomes}

      Total Taxation Amount : #{total_income}
      Amount this month: #{last_month_income}
      )

    %CreateIncomeOutputStruct{
      output_message: rendered_message,
      current_user: payload.current_user
    }
    |> TelegramContext.send_message()
  end

  defp get_total_income_by_user(user_id) do
    from(
      i in IncomeSchema,
      where: i.user_id == ^user_id,
      select: sum(i.target_amount)
    )
    |> Repo.one()
  end

  def get_last_month_income(user_id) do
    IncomeSchema
    |> where([i], i.user_id == ^user_id)
    |> order_by([i], asc: i.inserted_at)
    |> limit(1)
    |> select([i], i.amount * i.exchange_rate)
    |> Repo.one()
  end

  # TODO: get only records for this month
  defp get_last_month_incomes(user_id) do
    IncomeSchema
    |> where([i], i.user_id == ^user_id)
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
end
