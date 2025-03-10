defmodule TelegramTaxationBot.Taxations.Total.RenderTotal do
  @header ["Income", "Date", "Converted"]

  def call({:ok, input}) do
    total_stats = input.all_incomes |> render_stats_message()
    taxation_stats = taxation_info(input) |> render_message()
    month = input.month

    """
    ```
    Total for #{month}:
    #{total_stats}
    ```
    #{taxation_stats}
    """
  end

  def call({:error, :invalid_date}) do
    # "Формат этой даты... Похоже на эльфийский. Не могу прочесть."
    """
    Попробуй указать любой день нужного месяца
    /total YYYY-MM-DD
    """
  end

  defp taxation_info(input) do
    # TODO: make it buttons
    list = []
    list = [["1% tax to pay this month", "\n└`#{input.one_percent_tax}`"] | list]
    list = [["Total Month income (section 20)", "\n└`#{input.month_income}`"] | list]
    list = [["Total Taxation Amount (section 15)", "\n└`#{input.total_income}`"] | list]
    list
  end

  defp render_stats_message(incomes) do
    TableRex.Table.new(incomes, @header)
    |> TableRex.Table.put_column_meta(:all, align: :center, padding: 0)
    |> TableRex.Table.render!(horizontal_style: :off, vertical_style: :off)
  end

  defp render_message(incomes) do
    TableRex.Table.new(incomes)
    |> TableRex.Table.put_column_meta(:all, align: :left, padding: 2)
    |> TableRex.Table.render!(horizontal_style: :off, vertical_style: :off)
  end
end
