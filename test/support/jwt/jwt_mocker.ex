defmodule ServerUtils.Support.Jwt.JwtMocker do
  @moduledoc false

  import Joken

  @secret_key "secret_key"
  def secret_key, do: @secret_key

  @spec generate_json_token(String.t, integer()) :: String.t
  def generate_json_token(username, exp \\ 0) do
    %{username: username, exp: exp}
    |> token()
    |> with_signer(hs256(@secret_key))
    |> sign()
    |> get_compact()
  end

  @spec validate_token(String.t, String.t, integer()) :: atom()
  def validate_token(jwt, username, exp \\ 0) do
    jwt
    |> token()
    |> with_validation("username", &(&1 == username))
    |> with_validation("exp", &(&1 == exp))
    |> verify!(hs256(@secret_key))
    |> elem(0)
  end

end
