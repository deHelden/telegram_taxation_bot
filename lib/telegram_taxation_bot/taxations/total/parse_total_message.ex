defmodule TelegramTaxationBot.Taxations.Total.ParseTotalMessage do
  @regex ~r/\/total(?:\s(?<date>\d{4}-\d{2}-\d{2}))?/u

  def call(%{message: input_message}) do
    extract_attrs(input_message)
  end

  def valid_message?(input_message) do
    parsed = parse_message(input_message)

    !!parsed
  end

  defp extract_attrs(input_message) do
    case parse_message(input_message) do
      nil ->
        {:error, :invalid_format}

      parsed ->
        date = get_date(parsed["date"])
        {:ok, %{date: date}}
    end
  end

  defp get_date(nil), do: get_previous_month_date()

  defp get_date(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> Date.to_iso8601(date)
      {:error, _} -> get_previous_month_date()
    end
  end

  defp get_previous_month_date do
    Date.utc_today()
    |> Date.beginning_of_month()
    |> Date.add(-1)
    |> Date.to_iso8601()
  end

  defp parse_message(input_message) do
    Regex.named_captures(@regex, input_message)
  end
end
