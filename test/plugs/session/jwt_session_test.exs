defmodule ServerUtils.Plugs.Session.JwtSessionTest do
  @moduledoc false

  use ExUnit.Case

  import Plug.Conn

  alias Plug.Conn

  alias ServerUtils.Support.Jwt.JwtMocker

  alias ServerUtils.Plugs.Session.JwtSession

  @moduletag :units

  @fake_user_id "user@fake.is"

  test "Given a keyword when initialize the plug then the keyword is returned" do
    expected_result = [test: :test]
    initializated_result = JwtSession.init(expected_result)
    assert expected_result == initializated_result
  end

  describe "Given a conn request" do
    setup [:create_fixtures]

    test "when it contains the jwt header then the conn is returned", %{conn: conn, jwt: jwt} do
      conn = put_req_header(conn, "authorization", jwt)

      expected_conn = put_private(conn, :server_utils, %{user_id: @fake_user_id, jwt: jwt})

      validated_conn = JwtSession.call(conn, [])
      assert expected_conn == validated_conn
    end

    test "when it contains an invalid jwt header then an error is returned", %{conn: conn} do
      jwt = JwtMocker.generate_json_token("")

      conn = put_req_header(conn, "authorization", jwt)

      validated_conn = JwtSession.call(conn, [])

      assert validated_conn.halted == true
      assert validated_conn.status == 401
    end

    test "when it does not contain the jwt header then the conn halted with an error is returned",
         %{conn: conn} do
      response_conn = JwtSession.call(conn, [])

      assert response_conn.halted == true
      assert response_conn.status == 401
    end

    test "when it does not contain any header then the conn halted with an error is returned", %{
      conn: conn
    } do
      conn = Map.delete(conn, :req_headers)
      response_conn = JwtSession.call(conn, [])

      assert response_conn.halted == true
      assert response_conn.status == 401
    end
  end

  defp create_fixtures(_) do
    jwt = JwtMocker.generate_json_token(@fake_user_id)
    conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "/", nil)
    {:ok, jwt: jwt, conn: conn}
  end
end
