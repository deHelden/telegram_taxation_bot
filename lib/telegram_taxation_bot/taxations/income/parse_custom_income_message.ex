defmodule TelegramTaxationBot.Taxations.Income.ParseCustomTransactionMessage do
  @regex ~r/\/add\s*(?<amount>\d{1,3}(?:\s?\d{3})*(?:[\.,]\d*)?)\s(?<currency>\w+)\s(?<date>\d{4}-\d{2}-\d{2})/u

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
      amount =
        parsed["amount"]
        |> String.replace(",", ".")
        |> String.replace(~r/\s/, "")

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
