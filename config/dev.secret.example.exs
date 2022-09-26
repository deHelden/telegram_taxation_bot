import Config

# Configure your database
config :telegram_taxation_bot, TelegramTaxationBot.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "telegram_taxation_bot_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# token from botfather
config :nadia, token: "bot_father:token"

config :telegram_taxation_bot, currency_exchange_url: "https://url"
