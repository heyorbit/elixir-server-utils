defmodule ServerUtils.Plugs.CursorPageRequest do
  @moduledoc """
  Plug to build a paginated request.

  If there is no pagination params or they not fullfil the configureation a default page value will be used.
  """

  import Plug.Conn

  alias ServerUtils.Parsers.ParamsParser
  alias ServerUtils.Page.CursorPageRequest

  @spec init(Keyword.t()) :: Keyword.t()
  def init(default), do: default

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(%Plug.Conn{query_string: query_string} = conn, _default) do
    query_string
    |> URI.decode_query()
    |> ParamsParser.parse_cursor_page_request()
    |> set_page_request(conn)
  end

  def call(conn, _default), do: conn

  @spec set_page_request(CursorPageRequest.t(), Plug.Conn.t()) :: Plug.Conn.t()
  defp set_page_request(page_request, conn) do
    put_private(conn, :page_request, page_request)
  end
end
