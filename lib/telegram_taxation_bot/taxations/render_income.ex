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
    IO.inspect(input)
    render_message(input)
  end

  def render_message(income) do
    "AMOUNT IN GEL : #{income.target_amount}"
    "AMOUNT IN GEL : #{income.target_amount}"
    # #{transaction_header}
    # ```

    # #{table}
    # ```
    # """
  end
end
