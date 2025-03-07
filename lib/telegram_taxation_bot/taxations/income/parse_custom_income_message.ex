defmodule TelegramTaxationBot.Taxations.Income.ParseCustomTransactionMessage do
  @regex ~r/\/add\s*(?<amount>\d{1,3}(?:\s?\d{3})*(?:[\.,]\d*)?(?:\s?\d{1,3})*)\s(?<currency>\w+)(?:\sDate:|\s)(?<date>.+)/u

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
         validated_result when validated_result == true <- validate_parsed(parsed),
         {:ok, parsed_date} <- parse_date(parsed["date"]) do
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
          date: Date.to_iso8601(parsed_date)
        }
      }
    else
      _result -> {:error, :parse_error}
    end
  end

  defp parse_date(date_string) do
    date_formats = [
      # For "2024-08-01" format
      "{YYYY}-{0M}-{0D}",
      # For "1 Aug 2024" format
      "{D} {Mshort} {YYYY}"
    ]

    Enum.reduce_while(date_formats, {:error, :invalid_date}, fn format, acc ->
      case Timex.parse(date_string, format) do
        {:ok, datetime} -> {:halt, {:ok, Timex.to_date(datetime)}}
        {:error, _} -> {:cont, acc}
      end
    end)
  end

  defp parse_message(input_message) do
    Regex.named_captures(@regex, input_message)
  end

  defp validate_parsed(parsed) do
    !!(parsed && parsed["amount"] && parsed["date"] && parsed["currency"])
  end
end
