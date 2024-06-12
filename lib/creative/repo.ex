defmodule Creative.Repo do
  use AshPostgres.Repo,
    otp_app: :creative

  def installed_extensions do
    ["ash-functions", "citext"]
  end
end
