defmodule ServerUtils.Support.PlugCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn

      def put_private_page_request(conn, page_request) do
        put_private(conn, :server_utils, %{page_request: page_request})
      end

      def put_private_session(conn, session) do
        put_private(conn, :server_utils, %{session: session})
      end
    end
  end
end
