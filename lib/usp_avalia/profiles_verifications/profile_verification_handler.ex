defmodule UspAvalia.ProfilesVerifications.ProfileVerificationHandler do
  use Commanded.Event.Handler,
    application: UspAvalia.ComandedApp,
    name: __MODULE__

  def after_start(state) do
    IO.inspect("ProfileVerificationHandler started")
    IO.inspect(state)
    :ok
  end

  def handle(_event, _metadata) do
    IO.inspect("ProfileVerificationHandler received an event")
    :ok
  end
end
