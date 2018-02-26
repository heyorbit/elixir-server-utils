defmodule ServerUtils.Plugs.PageRequestTest do
  @moduledoc false

  use ExUnit.Case
  import Plug.Conn

  alias Plug.Conn

  alias ServerUtils.Plugs.PageRequest
  alias ServerUtils.Page.PageParams

  @moduletag :units

  @page_size_key Application.get_env(:server_utils, :page_size_key) || "page_size"
  @page_number_key Application.get_env(:server_utils, :page_number_key) || "page_number"
  @default_page_size_key Application.get_env(:server_utils, :page_size) || 10
  @default_page_number_key Application.get_env(:server_utils, :page_number) || 5
  @max_page_size Application.get_env(:server_utils, :max_page_size) || 25

  @page_request_number 23
  @page_request_size 5
  @page_request_query "#{@page_number_key}=#{@page_request_number}&#{@page_size_key}=#{@page_request_size}"

  test "Given a keyword when initialize the plug then the keyword is returned" do
    expected_result = [test: :test]
    initializated_result = PageRequest.init(expected_result)
    assert expected_result == initializated_result
  end

  describe "Given a conn request with a page request query" do
    setup [:create_fixtures]

    test "when parse the page request query then the conn with the page request is returned", %{conn: conn, page_request: page_request} do
      expected_conn = put_private(conn, :page_request, page_request)

      conn_with_page_request = PageRequest.call(conn, [])

      assert expected_conn == conn_with_page_request
    end

    test "when the query contains an invalid page request then the conn with the default page request is returned",
        %{default_page_request: default_page_request} do
      invalid_page_request_query_conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "/", nil)

      expected_conn = put_private(invalid_page_request_query_conn, :page_request, default_page_request)

      conn_with_page_request = PageRequest.call(invalid_page_request_query_conn, [])

      assert expected_conn == conn_with_page_request
    end

    test "when the query contains an invalid page request values then the conn with the default page request is returned",
        %{default_page_request: default_page_request} do
      invalid_page_request_query_conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "#{@page_number_key}=aaaa&#{@page_size_key}=bbbbbbb", nil)

      expected_conn = put_private(invalid_page_request_query_conn, :page_request, default_page_request)

      conn_with_page_request = PageRequest.call(invalid_page_request_query_conn, [])

      assert expected_conn == conn_with_page_request
    end

    test "when the page request params exceed the maximum size then the conn with the page request with the default page size is returned",
        %{default_page_request: default_page_request} do
      invalid_page_request_query_conn = Plug.Adapters.Test.Conn.conn(%Conn{},
        :get, "#{@page_number_key}=#{@page_request_number}&#{@page_size_key}=#{@max_page_size+10}", nil)

      expected_conn = put_private(invalid_page_request_query_conn, :page_request, default_page_request)

      conn_with_page_request = PageRequest.call(invalid_page_request_query_conn, [])

      assert expected_conn == conn_with_page_request
    end

  end

  defp create_fixtures(_) do
    page_request = %PageParams{page_number: @page_request_number, page_size: @page_request_size}
    default_page_request = %PageParams{page_number: @default_page_number_key, page_size: @default_page_size_key}

    conn = Plug.Adapters.Test.Conn.conn(%Conn{}, :get, "/?#{@page_request_query}", nil)

    {:ok, page_request: page_request, default_page_request: default_page_request, conn: conn}
  end

end
