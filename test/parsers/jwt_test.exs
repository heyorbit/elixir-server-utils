defmodule ServerUtils.Parsers.JwtTest do
  @moduledoc false

  use ExUnit.Case

  alias ServerUtils.Support.Jwt.JwtMocker
  alias ServerUtils.Parsers.Jwt, as: JwtParser

  @moduletag :unit

  @fake_username "fake_user"

  test "Given a jwt and a claim key when it exists then the claim value is returned" do
    claim_value =
      @fake_username
      |> JwtMocker.generate_json_token()
      |> JwtParser.get_claim("username")

    assert {:ok, @fake_username} == claim_value
  end

  test "Given a jwt and a claim key when it does not exist then an error is returned" do
    claim_value =
      @fake_username
      |> JwtMocker.generate_json_token()
      |> JwtParser.get_claim("missing_key")
      |> elem(0)

    assert :error == claim_value
  end

  test "Given an empty claim key when the option error if blank is provided then an error is returned" do
    claim_value =
      ""
      |> JwtMocker.generate_json_token()
      |> JwtParser.get_claim("username", error_if_blank: true)
      |> elem(0)

    assert :error == claim_value
  end

  test "Given a jwt when getting the claims then a map with the claims is returned" do
    {result, claims} =
      @fake_username
      |> JwtMocker.generate_json_token()
      |> JwtParser.get_claims()

    assert result == :ok
    assert claims == %{"exp" => 0, "username" => @fake_username}
  end
end
