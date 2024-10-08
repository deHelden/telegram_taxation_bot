defmodule TelegramTaxationBotWeb.BotController do
  use TelegramTaxationBotWeb, :controller
  # use TelegramTaxationBot.LoggerWithSentry
  alias TelegramTaxationBot.{CallbackData, MessageData, Pipelines}
  # alias TelegramTaxationBot.Steps.Telegram.SendMessage

  def webhook(conn, %{
        "callback_query" => %{
          "data" => callback_data,
          "id" => callback_id,
          "from" => from,
          "message" => %{
            "message_id" => message_id,
            "text" => message_text,
            "chat" => %{"id" => chat_id}
          }
        }
      }) do
    callback_data = Jason.decode!(callback_data)

    # try do
    %CallbackData{
      chat_id: chat_id,
      callback_data: callback_data,
      callback_id: callback_id,
      from: from,
      message_id: message_id,
      message_text: message_text
    }

    Nadia.send_message(chat_id, message_text)
    # |> Pipelines.call()

    # rescue
    #   e ->
    #     log_exception(e, __STACKTRACE__, %{callback_data: callback_data})

    #     message = "Случилось что-то страшное, и я не смог обработать запрос."

    #     # SendMessage.call(%{
    #     #   output_message: message,
    #     #   chat_id: chat_id
    #     # })
    # end

    json(conn, %{})
  end

  def webhook(
        conn,
        %{
          "message" => %{
            "text" => input_message,
            "chat" => %{"id" => chat_id},
            "from" => %{"username" => username}
          }
        }
      ) do
    # try do
    # reply_to_message = get_in(message, ["reply_to_message", "text"])

    %MessageData{
      message: input_message,
      name: username,
      chat_id: chat_id
    }
    |> Pipelines.call()

    # rescue
    #   e ->
    #     log_exception(e, __STACKTRACE__, %{input_message: input_message})

    #     message = "Случилось что-то страшное, и я не смог обработать запрос."

    #     SendMessage.call(%{
    #       output_message: message,
    #       chat_id: chat_id
    #     })
    # end

    json(conn, %{})
  end

  def webhook(conn, _params) do
    json(conn, %{})
  end
end
