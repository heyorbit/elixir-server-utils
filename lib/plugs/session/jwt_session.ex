defmodule ServerUtils.Plugs.Session.JwtSession do
  @moduledoc """
  Plug to intercept request and validate the presence of the JWT header
  """

  @behaviour Plug
  import Plug.Conn

  alias ServerUtils.Parsers.Jwt, as: JwtParser

  @authorization_header "authorization"

  @spec init(Keyword.t()) :: Keyword.t()
  def init(default), do: default

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(%Plug.Conn{req_headers: req_headers} = conn, _default) do
    if Enum.any?(req_headers, fn {header, _value} ->
         String.downcase(header) == @authorization_header
       end) do
      jwt =
        req_headers
        |> Enum.filter(fn {header, _value} -> String.downcase(header) == @authorization_header end)
        |> List.first()
        |> elem(1)

      case JwtParser.get_claim(jwt, "username", error_if_blank: true) do
        {:ok, user_id} ->
          session = %{user_id: user_id, jwt: jwt}
          put_private(conn, :server_utils, session)

        {:error, _} ->
          send_unauthorized_response(conn)
      end
    else
      send_unauthorized_response(conn)
    end
  end

  def call(conn, _default) do
    send_unauthorized_response(conn)
  end

  @spec send_unauthorized_response(Plug.Conn.t()) :: Plug.Conn.t()
  defp send_unauthorized_response(conn) do
    conn
    |> send_resp(:unauthorized, "missing authentication")
    |> halt()
  end
end
