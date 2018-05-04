defmodule ServerUtils.Plugs.Pagination.Classic.PageRequest do
  @moduledoc """
  Plug to build a paginated request.

  If there is no pagination params or they not fullfil the configureation a default page value will be used.
  """

  import Plug.Conn

  alias ServerUtils.Parsers.Pagination.Classic.Parser

  alias ServerUtils.Pagination.Classic.PageRequest

  @spec init(Keyword.t()) :: Keyword.t()
  def init(default), do: default

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(%Plug.Conn{query_string: query_string} = conn, _default) do
    query_string
    |> URI.decode_query()
    |> Parser.parse_page_params()
    |> set_page_request(conn)
  end

  def call(conn, _default), do: conn

  @spec set_page_request(PageRequest.t(), Plug.Conn.t()) :: Plug.Conn.t()
  defp set_page_request(user_id, conn) do
    put_private(conn, :page_request, user_id)
  end
end
