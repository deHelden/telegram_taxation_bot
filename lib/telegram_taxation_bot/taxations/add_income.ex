defmodule TelegramTaxationBot.Taxations.AddIncome do
  alias TelegramTaxationBot.Taxations.ParseCustomTransactionMessage
  alias TelegramTaxationBot.Taxations.Structs.CreateTaxation

  def call(%CreateTaxation{} = payload) do
    payload
    |> ParseCustomTransactionMessage.call()

    # get exchange_rates

    |> IO.inspect()

    # if check parsed exists && validate && get exchange_rates
    # do
    #   save to database
    # else
    #   :parse_error -> parse_error_message
    #   :fetch_exchange_error -> exchange_error_message
  end

  defp error_message do
    """
    Я не смог распознать твою команду добавления.

    Примеры команд, которые точно сработают:

    `/add 1000.2 USD 2022-01-01`
    `/add USD 1000.2 2022-01-01`
    """
  end
end
