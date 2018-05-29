defmodule ServerUtils.Session do
  @moduledoc """
  Structure that represents a JWT session
  """

  @typedoc """
  Session authentication which includes:
  - user_id: Unique user identifier for the current session
  - session: The JWT
  """
  @type t :: %__MODULE__{
          jwt: String.t(),
          payload: map
        }

  @enforce_keys [:jwt]

  defstruct [payload: %{}] ++ @enforce_keys
end
