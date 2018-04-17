defmodule ServerUtils.Jwt.JwtParserTest do
  use ExUnit.Case

  alias ServerUtils.Support.Jwt.JwtMocker
  alias ServerUtils.Jwt.JwtParser

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
end
