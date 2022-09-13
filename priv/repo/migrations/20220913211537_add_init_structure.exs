defmodule TelegramTaxationBot.Repo.Migrations.AddInitStructure do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string, default: "User", null: false)
      add(:telegram_chat_id, :bigint, null: false)

      timestamps()
    end

    create table(:incomes) do
      add(:user_id, references(:users))
      add(:date, :date, null: false)
      add(:amount, :decimal, null: false)
      add(:currency, :string, size: '3', null: false)
      add(:exchange_rate, :decimal, null: false)
      add(:target_amount, :decimal, null: false)

      timestamps()
    end

    create table(:taxations) do
      add(:user_id, references(:users))
      add(:date, :date, null: false)
      add(:monthly_amount, :decimal, null: false)
      add(:yearly_amount, :decimal, null: false)

      timestamps()
    end
  end
end
