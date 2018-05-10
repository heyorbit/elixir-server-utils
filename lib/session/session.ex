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
          user_id: any(),
          jwt: String.t()
        }

  @enforce_keys [:jwt, :user_id]

  defstruct @enforce_keys
end
