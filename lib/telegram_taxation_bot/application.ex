defmodule TelegramTaxationBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias TelegramTaxationBot.CurrencyApi

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TelegramTaxationBot.Repo,
      # Start the Telemetry supervisor
      TelegramTaxationBotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TelegramTaxationBot.PubSub},
      # Start the Endpoint (http/https)
      TelegramTaxationBotWeb.Endpoint,
      # Start a worker by calling: TelegramTaxationBot.Worker.start_link(arg)
      # {TelegramTaxationBot.Worker, arg}
      CurrencyApi.child_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TelegramTaxationBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TelegramTaxationBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
