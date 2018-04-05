defmodule ServerUtils.Plugs.SessionTokenValidator do
  @moduledoc """
  Plug to intercept request and validate the presence of the JWT header
  """

  @behaviour Plug
  import Plug.Conn

  alias ServerUtils.Jwt.JwtParser

  @authorization_header "authorization"

  @spec init(Keyword.t()) :: Keyword.t()
  def init(default), do: default

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(%Plug.Conn{req_headers: req_headers} = conn, _default) do
    if Enum.any?(req_headers, fn {header, _value} ->
         String.downcase(header) == @authorization_header
       end) do
      user_id =
        req_headers
        |> Enum.filter(fn {header, _value} -> String.downcase(header) == @authorization_header end)
        |> List.first()
        |> elem(1)
        |> JwtParser.get_claim("username", error_if_blank: true)

      case user_id do
        {:ok, user_id} ->
          set_decoded_jwt_data(user_id, conn)

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

  @spec set_decoded_jwt_data(String.t(), Plug.Conn.t()) :: Plug.Conn.t()
  defp set_decoded_jwt_data(user_id, conn) do
    put_private(conn, :user_id, user_id)
  end
end
