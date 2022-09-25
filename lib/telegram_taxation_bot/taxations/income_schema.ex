defmodule TelegramTaxationBot.Taxations.IncomeSchema do
  use Ecto.Schema

  schema "incomes" do
    field(:date, :date)
    field(:amount, :decimal)
    field(:currency, :string)
    field(:exchange_rate, :decimal)
    field(:target_amount, :decimal)

    timestamps()
  end
end
