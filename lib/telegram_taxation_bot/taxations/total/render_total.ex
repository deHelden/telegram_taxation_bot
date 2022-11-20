defmodule TelegramTaxationBot.Taxations.Total.RenderTotal do
  @header ["Amount", "Currency", "Date", "Converted"]

  def call(input) do
    total_stats = input.all_incomes |> render_stats_message()
    taxation_stats = taxation_info(input) |> render_message()

    """
    ```
    #{total_stats}

    #{taxation_stats}
    ```
    """
  end

  defp taxation_info(input) do
    list = []
    list = [["1% tax to pay", input.one_percent_tax] | list]
    list = [["Amount in month 'date'", input.month_income] | list]
    list = [["Total Taxation Amount", input.total_income] | list]
    list
  end

  defp render_stats_message(incomes) do
    TableRex.Table.new(incomes, @header)
    |> TableRex.Table.put_column_meta(:all, align: :center, padding: 1)
    |> TableRex.Table.render!(horizontal_style: :off, vertical_style: :off)
  end

  defp render_message(incomes) do
    TableRex.Table.new(incomes)
    |> TableRex.Table.put_column_meta(:all, align: :left, padding: 0)
    |> TableRex.Table.render!(horizontal_style: :off, vertical_style: :off)
  end
end
