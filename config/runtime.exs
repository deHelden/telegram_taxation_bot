# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

if config_env() == :prod do
  defmodule Helpers do
    def get_env(name) do
      case System.get_env(name) do
        nil -> raise "Environment variable #{name} is not set!"
        val -> val
      end
    end
  end

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :telegram_taxation_bot, TelegramTaxationBot.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :telegram_taxation_bot, TelegramTaxationBotWeb.Endpoint,
    force_ssl: [hsts: true],
    https: [
      port: 443,
      compress: true,
      cipher_suite: :strong,
      keyfile: Helpers.get_env("CO2_OFFSET_SSL_KEY_PATH"),
      cacertfile: Helpers.get_env("CO2_OFFSET_SSL_CACERT_PATH"),
      certfile: Helpers.get_env("CO2_OFFSET_SSL_CERT_PATH"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base

  # ## Using releases (Elixir v1.9+)
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  config :telegram_taxation_bot, TelegramTaxationBotWeb.Endpoint, server: true
  config :nadia, token: Helpers.get_env("TELEGRAM_TOKEN")

  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.
end
