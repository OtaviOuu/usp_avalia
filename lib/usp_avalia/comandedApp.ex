defmodule UspAvalia.ComandedApp do
  use Commanded.Application,
    otp_app: :usp_avalia

  router(UspAvalia.ProfilesVerifications.ProfileRouter)
end
