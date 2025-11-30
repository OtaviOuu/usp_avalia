defmodule UspAvalia.Repo do
  use Ecto.Repo,
    otp_app: :usp_avalia,
    adapter: Ecto.Adapters.Postgres
end
