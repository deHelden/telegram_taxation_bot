defmodule TelegramTaxationBot.Taxations.DeleteIncome do
  import Ecto.Query
  alias TelegramTaxationBot.Repo

  alias TelegramTaxationBot.Taxations.Structs.{CreateTaxation, CreateIncomeOutputStruct}
  alias TelegramTaxationBot.Taxations.IncomeSchema
  alias TelegramTaxationBot.TelegramContext

  def call(%CreateTaxation{} = payload) do
    user_id = payload.current_user.id

    IncomeSchema
    |> where([i], i.user_id == ^user_id)
    |> Repo.delete_all()

    # |> create_income_changeset()
    # |> TelegramTaxationBot.Repo.delete!()

    rendered_message = "🕵🏻‍♂️ Я стер все твои поступления."

    %CreateIncomeOutputStruct{
      output_message: rendered_message,
      current_user: payload.current_user
    }
    |> TelegramContext.send_message()
  end
end
