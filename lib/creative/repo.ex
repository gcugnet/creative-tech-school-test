defmodule Creative.Repo do
  use Ecto.Repo,
    otp_app: :creative,
    adapter: Ecto.Adapters.Postgres
end
