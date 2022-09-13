defmodule TelegramTaxationBot.Repo do
  use Ecto.Repo,
    otp_app: :telegram_taxation_bot,
    adapter: Ecto.Adapters.Postgres
end
