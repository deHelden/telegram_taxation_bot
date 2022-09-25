defmodule TelegramTaxationBot.Users do
  import Ecto.Changeset

  alias TelegramTaxationBot.MessageData
  alias TelegramTaxationBot.Users.InputGate
  alias TelegramTaxationBot.Users.User
  alias TelegramTaxationBot.Repo
  # create user
  def create_user(%MessageData{} = users_input) do
    # input = InputGate.coerse_create_user_input(users_input)
    users_input
    # преобразовывать входные данные
    |> InputGate.coerse_create_user_input()
    |> create_user_changeset()
    |> Repo.insert!()

    # |> IO.inspect()

    # we should make output gate for result of this func
  end

  defp create_user_changeset(input) do
    %User{}
    # Like input gate but  for repo
    |> cast(input, [:telegram_chat_id, :name])
    |> validate_required([:telegram_chat_id, :name])
    |> unique_constraint(:telegram_chat_id)
  end
end
