defmodule ServerUtils.Plugs.Session.JwtSession do
  @moduledoc """
  Plug to intercept request and validate the presence of the JWT header
  """

  @behaviour Plug
  import Plug.Conn

  alias ServerUtils.Parsers.Jwt, as: JwtParser
  alias ServerUtils.SentryLogger

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

      put_session(conn, jwt)
    else
      SentryLogger.debug("Header for authorization not found: #{@authorization_header}")
      send_unauthorized_response(conn)
    end
  end

  def call(conn, _default) do
    send_unauthorized_response(conn)
  end

  @spec put_session(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
  def put_session(conn, jwt) do
    with {:ok, payload} <- JwtParser.get_claims(jwt) do
      session = %{session: %ServerUtils.Session{jwt: jwt, payload: payload}}
      private = Map.merge(conn.private[:server_utils] || %{}, session)
      put_private(conn, :server_utils, private)
    else
      {:error, _} ->
        SentryLogger.info("Unable to parse claims from jwt: #{jwt}")
        send_unauthorized_response(conn)
    end
  end

  @spec send_unauthorized_response(Plug.Conn.t()) :: Plug.Conn.t()
  defp send_unauthorized_response(conn) do
    conn
    |> send_resp(:unauthorized, "missing authentication")
    |> halt()
  end
end
