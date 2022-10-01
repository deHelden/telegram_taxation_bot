defmodule TelegramTaxationBot.Taxations.RenderIncome do
  # %TelegramTaxationBot.Taxations.IncomeSchema{
  #   __meta__: #Ecto.Schema.Metadata<:loaded, "incomes">,
  #   amount: #Decimal<6565>,
  #   currency: "USD",
  #   date: ~D[2022-09-27],
  #   exchange_rate: #Decimal<2.8344>,
  #   id: 66,
  #   inserted_at: ~N[2022-09-27 14:09:47],
  #   target_amount: #Decimal<18607.84>,
  #   updated_at: ~N[2022-09-27 14:09:47],
  #   user_id: 1
  # }

  def call(input) do
    render_message(input)
  end

  def render_message(income) do
    # table =
    table_data(income)
    |> TableRex.Table.new([], "")
    |> TableRex.Table.put_column_meta(0, padding: 0)
    |> TableRex.Table.render!(horizontal_style: :off, vertical_style: :off)

    # ~s(#{table})
  end

  defp table_data(input) do
    list = []
    list = [["Сумма", input.amount] | list]
    list = [["Валюта", input.currency] | list]
    list = [["Дата", input.date] | list]
    list = [["Курс", input.exchange_rate] | list]
    list = [["GEL", input.target_amount] | list]

    list
  end
end
