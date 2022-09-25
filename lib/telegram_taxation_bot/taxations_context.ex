defmodule TelegramTaxationBot.TaxationsContext do
  # import Ecto.Changeset

  alias TelegramTaxationBot.Taxations.InputGate
  # alias TelegramTaxationBot.Taxations.Income
  # alias TelegramTaxationBot.Repo
  alias TelegramTaxationBot.MessageData
  alias TelegramTaxationBot.Taxations.AddIncome
  # create user
  def create_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> AddIncome.call()

    # |> create_income_changeset()

    # |> Repo.insert!()

    # |> IO.inspect()

    # we should make output gate for result of this func
  end

  # defp create_income_changeset(input) do
  #   %Income{}
  #   # Like input gate but  for repo
  #   |> cast(input, [:telegram_chat_id, :name])
  #   |> validate_required([:telegram_chat_id, :name])
  #   |> unique_constraint(:telegram_chat_id)
  # end
end
