defmodule TelegramTaxationBot.CurrencyApi do
  @api_url Application.compile_env(:telegram_taxation_bot, :currency_exchange_url)
  @pool_size 25

  # this is about child application in main application (probably will scale)
  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       @api_url => [size: @pool_size]
     }}
  end

  # working copy of fetch rate
  def get_rates(date, currency) do
    url = make_api_url(date, currency)

    headers = [
      {"Accept", "application/json, text/plain, */*"},
      {"Content-Type", "application/json;charset=UTF-8"}
    ]

    :get
    |> Finch.build(url, headers)
    |> Finch.request(__MODULE__)
    |> get_json_body()
    # maybe sort by date before taking the last one
    |> Enum.at(-1)
    |> Access.get("currencies")
    |> Enum.at(0)
  end

  def get_json_body({_state, %Finch.Response{body: body, headers: _headers, status: _status}}) do
    body
    |> Jason.decode!()
  end

  def make_api_url(date, currency) do
    "#{@api_url}/?currencies=#{currency}&date=#{date}"
  end
end
