defmodule UspAvalia.EventStore do
  use EventStore, otp_app: :usp_avalia

  def init(config) do
    {:ok, config}
  end
end
