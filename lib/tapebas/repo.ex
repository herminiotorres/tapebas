defmodule Tapebas.Repo do
  use Ecto.Repo,
    otp_app: :tapebas,
    adapter: Ecto.Adapters.Postgres
end
