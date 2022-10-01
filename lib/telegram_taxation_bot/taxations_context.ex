defmodule TelegramTaxationBot.TaxationsContext do
  alias TelegramTaxationBot.MessageData

  alias TelegramTaxationBot.Taxations.{
    InputGate,
    AddIncome,
    # DeleteIncome,
    ShowTotal
  }

  def create_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> AddIncome.call()
  end

  # def delete_income(%MessageData{} = income_input) do
  #   income_input
  #   |> InputGate.coerse_create_income_input()
  #   |> DeleteIncome.call()
  # end

  def total_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_total_input()
    |> ShowTotal.call()
  end
end
