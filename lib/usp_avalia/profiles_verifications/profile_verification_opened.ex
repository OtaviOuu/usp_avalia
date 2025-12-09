defmodule UspAvalia.ProfilesVerifications.ProfileVerificationOpened do
  @derive Jason.Encoder
  defstruct [:user_id, :trys]
end
