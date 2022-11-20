defmodule TelegramTaxationBot.Taxations.Income.ParseCustomTransactionMessage do
  @regex ~r/\/add\s(?<amount>\d+[\.,]?\d*)\s(?<currency>\w+)\s(?<date>\d+-\d+-\d+)/u

  def call(%{message: input_message}) do
    extract_attrs(input_message)
  end

  def valid_message?(input_message) do
    parsed = parse_message(input_message)

    !!parsed
  end

  defp extract_attrs(input_message) do
    parse_message(input_message)

    with parsed when parsed != nil <- parse_message(input_message),
         validated_result when validated_result == true <- validate_parsed(parsed) do
      amount = String.replace(parsed["amount"], ",", ".")

      {decimal_amount, _} = Decimal.parse(amount)

      # TODO: add correct currency code for show
      {
        :parsed,
        %{
          amount: decimal_amount,
          currency: parsed["currency"],
          date: parsed["date"]
        }
      }
    else
      _result -> {:error, :parse_error}
    end
  end

  defp parse_message(input_message) do
    Regex.named_captures(@regex, input_message)
  end

  defp validate_parsed(parsed) do
    !!(parsed && parsed["amount"] && parsed["date"] && parsed["currency"])
  end
end
