defmodule TelegramTaxationBot.Taxations.ParseDeleteTransactionMessage do
  @regex ~r/\/del\s(?<id>\d+)/u

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
      %{id: parsed["id"]}
    else
      _result -> false
    end
  end

  defp parse_message(input_message) do
    Regex.named_captures(@regex, input_message)
  end

  defp validate_parsed(parsed) do
    !!(parsed && parsed["id"])
  end
end
