defmodule TelegramTaxationBot.UsersContext do
  import Ecto.Changeset
  import Ecto.Query

  alias TelegramTaxationBot.MessageData
  alias TelegramTaxationBot.Users.InputGate
  alias TelegramTaxationBot.Users.UserSchema
  alias TelegramTaxationBot.Repo
  # create user
  def(create_user(%MessageData{} = users_input)) do
    # input = InputGate.coerse_create_user_input(users_input)
    users_input
    # преобразовывать входные данные
    |> InputGate.coerse_create_user_input()
    |> create_user_changeset()
    |> Repo.insert!()

    # |> IO.inspect()

    # we should make output gate for result of this func
  end

  def get_user_by_chat_id(chat_id) do
    from(
      u in UserSchema,
      where: u.telegram_chat_id == ^chat_id
    )
    |> Repo.one()
  end

  defp create_user_changeset(input) do
    %UserSchema{}
    # Like input gate but  for repo
    |> cast(input, [:telegram_chat_id, :name])
    |> validate_required([:telegram_chat_id, :name])
    |> unique_constraint(:telegram_chat_id)
  end
end
