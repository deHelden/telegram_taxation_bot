defmodule TelegramTaxationBot.Taxations.DeleteIncome do
  alias TelegramTaxationBot.Taxations.Structs.{CreateTaxation, CreateIncomeOutputStruct}
  alias TelegramTaxationBot.Taxations.ParseDeleteTransactionMessage
  alias TelegramTaxationBot.Taxations.IncomeSchema
  alias TelegramTaxationBot.TelegramContext

  import Ecto.Changeset

  def call(%CreateTaxation{} = payload) do
    input = payload |> ParseDeleteTransactionMessage.call()
    IO.inspect(input.id)

    rendered_message = %{
      id: input.id
    }

    IO.inspect(rendered_message)
    # |> create_income_changeset()
    # |> TelegramTaxationBot.Repo.delete!()

    # %CreateIncomeOutputStruct{
    #   output_message: rendered_message,
    #   current_user: payload.current_user
    # }
    # |> TelegramContext.send_message()
  end

  defp create_income_changeset(input) do
    %IncomeSchema{}
    |> cast(input, :id)
    |> validate_required(:id)
  end
end
