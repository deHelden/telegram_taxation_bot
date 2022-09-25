defmodule TelegramTaxationBot.Taxations.TaxationSchema do
  use Ecto.Schema

  schema "taxations" do
    field(:date, :date)
    field(:monthly_amount, :decimal)
    field(:yearly_amount, :decimal)

    timestamps()
  end
end
