defmodule ServerUtils.Support.Jwt.JwtMockerTest do
  use ExUnit.Case

  import Joken

  alias ServerUtils.Support.Jwt.JwtMocker

  @moduletag :unit

  test "Given a username and a jwt when generate a nested jwt then a new jwt is returned" do
    generated_jwt = JwtMocker.generate_json_token("fake_user")

    is_jwt_valid =
      generated_jwt
      |> token()
      |> with_validation("username", &(&1 == "fake_user"))
      |> verify!(hs256(JwtMocker.secret_key()))
      |> elem(0)

    assert :ok == is_jwt_valid
  end

  test "Given a valid nested jwt when validate it then a ok is returned" do
    is_jwt_valid =
      "fake_user"
      |> JwtMocker.generate_json_token()
      |> JwtMocker.validate_token("fake_user")

    assert :ok == is_jwt_valid
  end
end
