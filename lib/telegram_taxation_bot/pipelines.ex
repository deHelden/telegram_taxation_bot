# конец контекста телеги
defmodule TelegramTaxationBot.Pipelines do
  alias TelegramTaxationBot.MessageData
  alias TelegramTaxationBot.UsersContext
  alias TelegramTaxationBot.TaxationsContext
  alias TelegramTaxationBot.TelegramContext

  alias TelegramTaxationBot.Taxations.Structs.CreateIncomeOutputStruct

  def call(%MessageData{message: "/start"} = message_data) do
    user =
      UsersContext.get_user_by_chat_id(message_data.chat_id) ||
        UsersContext.create_user(message_data)

    Nadia.send_message(user.telegram_chat_id, "О, новый пользователь! Приятно познакомиться!")
  end

  def call(%MessageData{chat_id: chat_id} = message_data) do
    user = UsersContext.get_user_by_chat_id(chat_id)

    if user do
      Map.put(message_data, :current_user, user)
      |> call_with_user()
    else
      # TODO: call telegram context to send message that user need to type /start
      # problem that context need ID which is after /start
    end
  end

  # add transaction with currency
  defp call_with_user(%MessageData{message: "/add" <> _rest} = message_data) do
    TaxationsContext.create_income(message_data)
  end

  defp call_with_user(%MessageData{message: "/clean" <> _rest} = message_data) do
    TaxationsContext.clean_incomes(message_data)
  end

  defp call_with_user(%MessageData{message: "/total" <> _rest} = message_data) do
    with {:ok, :record_exist} <- TaxationsContext.income_exist?(message_data) do
      TaxationsContext.total_income(message_data)
    else
      {:error, :empty_incomes} -> render_no_income_message(message_data)
    end
  end

  # if any message
  defp call_with_user(%MessageData{message: _message}) do
    # TODO: log unpredicted messages
  end

  def render_no_income_message(message_data) do
    message = ~s(
      Я пока не записал поступлений.
      \r\nДобавь пожалуйста через /add"
    )

    %CreateIncomeOutputStruct{
      output_message: message,
      current_user: message_data.current_user
    }
    |> TelegramContext.send_message()
  end
end
