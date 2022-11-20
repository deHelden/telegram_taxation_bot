defmodule TelegramTaxationBot.TaxationsContext do
  import Ecto.Query
  alias TelegramTaxationBot.Repo
  alias TelegramTaxationBot.MessageData

  alias TelegramTaxationBot.Taxations.Income.{
    InputGate,
    IncomeSchema,
    AddIncome,
    DeleteIncome
  }

  alias TelegramTaxationBot.Taxations.Total.ShowTotal

  def create_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> AddIncome.call()
  end

  def clean_incomes(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> DeleteIncome.call()
  end

  def income_exist?(%MessageData{} = income_input) do
    user_id = income_input.current_user.id

    record =
      IncomeSchema
      |> where([i], i.user_id == ^user_id)
      |> limit(1)
      |> Repo.one()

    if record do
      {:ok, :record_exist}
    else
      {:error, :empty_incomes}
    end
  end

  def total_income(%MessageData{} = income_input) do
    income_input
    |> InputGate.coerse_create_income_input()
    |> ShowTotal.call()
  end
end
