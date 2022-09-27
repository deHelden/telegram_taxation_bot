defmodule TelegramTaxationBot.Repo.Migrations.DeleteTaxation do
  use Ecto.Migration

  def change do
    drop table(:taxations)
  end
end
