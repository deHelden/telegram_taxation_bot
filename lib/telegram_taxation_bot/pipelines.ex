defmodule TelegramTaxationBot.Pipelines do
  alias TelegramTaxationBot.MessageData
  alias TelegramTaxationBot.Repo
  alias TelegramTaxationBot.Users
  alias TelegramTaxationBot.Users.User

  import Ecto.Query, only: [from: 2]

  def call(%MessageData{message: "/start"} = message_data) do
    # StartMessagesPipeline.call(message_data)

    # rename Users to UsersContext
    user = get_user_by_chat_id(message_data.chat_id) || Users.create_user(message_data)
    Nadia.send_message(user.telegram_chat_id, "user_was created: #{user.id}")
  end

  def get_user_by_chat_id(chat_id) do
    Repo.one(from u in User, where: u.telegram_chat_id == ^chat_id)
  end

  # if any message
  # def call(%MessageData{message: _message} = message_data) do
  #   message_data
  # end
end
