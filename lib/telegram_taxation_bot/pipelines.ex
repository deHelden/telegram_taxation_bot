# конец контекста телеги
defmodule TelegramTaxationBot.Pipelines do
  alias TelegramTaxationBot.MessageData
  alias TelegramTaxationBot.UsersContext
  alias TelegramTaxationBot.TaxationsContext

  def call(%MessageData{message: "/start"} = message_data) do
    # StartMessagesPipeline.call(message_data)

    # rename Users to UsersContext
    user =
      UsersContext.get_user_by_chat_id(message_data.chat_id) ||
        UsersContext.create_user(message_data)

    Nadia.send_message(user.telegram_chat_id, "user_was created: #{user.id}")
  end

  def call(%MessageData{chat_id: chat_id} = message_data) do
    user = UsersContext.get_user_by_chat_id(chat_id)

    if user do
      Map.put(message_data, :current_user, user)
      |> call_with_user()
    else
      # TODO: call telegram context to send message that user need to type /start
    end
  end

  # add transaction with currency
  def call_with_user(%MessageData{message: "/add" <> _rest} = message_data) do
    # user = get_user_by_chat_id(message_data.chat_id) || UsersContext.create_user(message_data)

    TaxationsContext.create_income(message_data)
    # call taxation context

    # Nadia.send_message(user.telegram_chat_id, "message_added: #{message}")
  end

  # if any message
  def call_with_user(%MessageData{message: _message} = message_data) do
    user =
      UsersContext.get_user_by_chat_id(message_data.chat_id) ||
        UsersContext.create_user(message_data)

    Nadia.send_message(user.telegram_chat_id, "not supported message")
  end
end
