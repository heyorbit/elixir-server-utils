defmodule ServerUtils.Plugs.CursorPageRequestTest do
  @moduledoc false
  @moduletag [:pagination, :cursor]

  use ServerUtils.Support.PlugCase

  alias Plug.Conn

  alias ServerUtils.Plugs.Pagination.Cursor.PageRequest, as: CursorPageRequestPlug

  alias ServerUtils.Pagination.Cursor.PageRequest

  @cursor_key Application.get_env(:server_utils, :cursor_key) || "cursor"
  @number_of_items_key Application.get_env(:server_utils, :number_of_items_key) ||
                         "number_of_items"

  @default_cursor ""
  @default_number_of_items 25

  @max_number_of_items Application.get_env(:server_utils, :max_number_of_items) || 25

  @cursor_mock Application.get_env(:server_utils, :default_cursor) || "a_cursor_value"
  @number_of_items Application.get_env(:server_utils, :default_number_of_items) || 25
  @page_request_query "#{@cursor_key}=#{@cursor_mock}&#{@number_of_items_key}=#{@number_of_items}"

  test "Given a keyword when initialize the plug then the keyword is returned" do
    expected_result = [test: :test]
    initializated_result = CursorPageRequestPlug.init(expected_result)
    assert expected_result == initializated_result
  end

  describe "Given a conn request with a page request query" do
    setup [:create_fixtures]

    test "when parse the page request query then the conn with the page request is returned", %{
      conn: conn,
      page_request: page_request
    } do
      expected_conn = put_private_page_request(conn, page_request)

      conn_with_page_request = CursorPageRequestPlug.call(conn, [])

      assert expected_conn == conn_with_page_request
    end

    test "when the query contains an invalid page request then the conn with the default page request is returned",
         %{default_page_request: default_page_request} do
      invalid_page_request_query_conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "/", nil)

      expected_conn =
        put_private_page_request(invalid_page_request_query_conn, default_page_request)

      conn_with_page_request = CursorPageRequestPlug.call(invalid_page_request_query_conn, [])

      assert expected_conn == conn_with_page_request
    end

    test "when the query contains an invalid page request values then the conn with the default page request is returned",
         %{default_page_request: default_page_request} do
      invalid_page_request_query_conn =
        Plug.Adapters.Test.Conn.conn(
          %Conn{},
          :get,
          "#{@cursor_key}=aaaa&#{@number_of_items}=bbbbbbb",
          nil
        )

      expected_conn =
        put_private_page_request(invalid_page_request_query_conn, default_page_request)

      conn_with_page_request = CursorPageRequestPlug.call(invalid_page_request_query_conn, [])

      assert expected_conn == conn_with_page_request
    end

    test "when the page request params exceed the maximum size then the conn with the page request with the default page size is returned",
         %{default_page_request: default_page_request} do
      invalid_page_request_query_conn =
        Plug.Adapters.Test.Conn.conn(
          %Conn{},
          :get,
          "#{@cursor_key}=#{@default_cursor}&#{@number_of_items}=#{@max_number_of_items + 10}",
          nil
        )

      expected_conn =
        put_private_page_request(invalid_page_request_query_conn, default_page_request)

      conn_with_page_request = CursorPageRequestPlug.call(invalid_page_request_query_conn, [])

      assert expected_conn == conn_with_page_request
    end
  end

  defp create_fixtures(_) do
    page_request = %PageRequest{
      cursor: @cursor_mock,
      number_of_items: @number_of_items
    }

    default_page_request = %PageRequest{
      cursor: @default_cursor,
      number_of_items: @default_number_of_items
    }

    conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "/?#{@page_request_query}", nil)

    {:ok, page_request: page_request, default_page_request: default_page_request, conn: conn}
  end
end
