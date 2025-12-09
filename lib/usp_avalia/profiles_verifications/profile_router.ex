defmodule UspAvalia.ProfilesVerifications.ProfileRouter do
  use Commanded.Commands.Router

  dispatch(UspAvalia.ProfilesVerifications.OpenProfileVerification,
    to: UspAvalia.ProfilesVerifications.Profile,
    identity: :user_id
  )
end
