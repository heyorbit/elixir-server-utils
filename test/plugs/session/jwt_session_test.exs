defmodule ServerUtils.Plugs.Session.JwtSessionTest do
  @moduledoc false

  use ServerUtils.Support.PlugCase

  import Plug.Conn

  alias Plug.Conn

  alias ServerUtils.Support.Jwt.JwtMocker

  alias ServerUtils.Plugs.Session.JwtSession

  @moduletag :units

  @fake_user_id "user@fake.is"
  @fake_exp 23

  test "Given a keyword when initialize the plug then the keyword is returned" do
    expected_result = [test: :test]
    initializated_result = JwtSession.init(expected_result)
    assert expected_result == initializated_result
  end

  describe "Given a conn request" do
    setup [:create_fixtures]

    test "when it contains the jwt header then the conn is returned", %{conn: conn, jwt: jwt} do
      conn = put_req_header(conn, "authorization", jwt)

      expected_conn =
        put_private_session(conn, %ServerUtils.Session{
          jwt: jwt,
          payload: %{"username" => @fake_user_id, "exp" => @fake_exp}
        })

      validated_conn = JwtSession.call(conn, [])
      assert expected_conn == validated_conn
    end

    test "when it contains an invalid jwt then an error is returned", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "invalid_token")

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
    jwt = JwtMocker.generate_json_token(@fake_user_id, @fake_exp)
    conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "/", nil)
    {:ok, jwt: jwt, conn: conn}
  end
end
