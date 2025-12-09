defmodule UspAvalia.ProfilesVerifications.Profile do
  defstruct [:user_id, :trys]

  alias Commanded.Aggregates.Aggregate
  alias UspAvalia.ProfilesVerifications

  @behaviour Aggregate

  @impl Aggregate
  def execute(
        %ProfilesVerifications.Profile{} = _profile,
        %ProfilesVerifications.OpenProfileVerification{
          user_id: user_id,
          trys: trys
        }
      ) do
    %ProfilesVerifications.ProfileVerificationOpened{
      user_id: user_id,
      trys: trys
    }
  end

  @impl Aggregate
  def apply(
        %ProfilesVerifications.Profile{} = profile,
        %ProfilesVerifications.ProfileVerificationOpened{
          user_id: user_id,
          trys: trys
        }
      ) do
    %ProfilesVerifications.Profile{
      profile
      | user_id: user_id,
        trys: trys
    }
  end
end
