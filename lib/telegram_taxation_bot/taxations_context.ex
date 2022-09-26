defmodule TelegramTaxationBot.TaxationsContext do
  alias TelegramTaxationBot.Taxations.AddIncome
  alias TelegramTaxationBot.Taxations.InputGate
  alias TelegramTaxationBot.MessageData

  def create_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> AddIncome.call()

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
