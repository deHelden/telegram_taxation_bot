defmodule TelegramTaxationBot.Taxations.Total.ParseTotalMessage do
  @regex ~r/\/total\s(?<date>\d+-\d+-\d+)/u

  def call(%{message: input_message}) do
    extract_attrs(input_message)
  end

  def valid_message?(input_message) do
    parsed = parse_message(input_message)

    !!parsed
  end

  defp extract_attrs(input_message) do
    # TODO: get rid of with monad
    with parsed when parsed != nil <- parse_message(input_message),
         validated_result when validated_result == true <- validate_parsed(parsed) do
      {:ok, %{date: parsed["date"]}}
    else
      _ ->
        {:error, :invalid_date}
    end
  end

  defp parse_message(input_message) do
    Regex.named_captures(@regex, input_message)
  end

  defp validate_parsed(parsed) do
    !!(parsed && parsed["date"])
  end
end
