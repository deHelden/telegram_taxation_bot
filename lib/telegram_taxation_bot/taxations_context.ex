defmodule TelegramTaxationBot.TaxationsContext do
  alias TelegramTaxationBot.Taxations.AddIncome
  alias TelegramTaxationBot.Taxations.InputGate
  alias TelegramTaxationBot.MessageData

  def create_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> AddIncome.call()
  end
end
