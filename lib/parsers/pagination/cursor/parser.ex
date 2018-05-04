defmodule ServerUtils.Parsers.Pagination.Cursor.Parser do
  @moduledoc """
  Parses a map with a cursor page request to a `ServerUtils.Page.CursorPageRequest` struct.

  Any missing values will be get the default values. The default values can be configured via the config file
  or overrided using `default_values_opts`.
  """

  alias ServerUtils.Pagination.Cursor.PageRequest
  alias ServerUtils.Parsers.Pagination

  @cursor_key Application.get_env(:server_utils, :cursor_key) || "cursor"
  @page_number_of_items_key Application.get_env(:server_utils, :number_of_items_key) ||
                              "number_of_items"

  @default_cursor ""
  @default_number_of_items 25
  @default_max_number_of_items 100

  @type default_values_opts :: [
          cursor: String.t(),
          number_of_items: non_neg_integer,
          max_number_of_items: non_neg_integer
        ]

  @doc """
  Parses a page params from a cursor pagination request.

  It returns the `CursorPageRequest.t` with the present values and with the default.

  ## Examples

      iex> #{__MODULE__}.parse_cursor_page_request(%{"cursor" => "a_cursor", "number_of_items" => 23})
      %ServerUtils.Pagination.Cursor.PageRequest{cursor: "a_cursor", number_of_items: 23}

      iex> #{__MODULE__}.parse_cursor_page_request(%{"cursor" => "a_cursor", "number_of_items" => 9000})
      %ServerUtils.Pagination.Cursor.PageRequest{cursor: "a_cursor",
      number_of_items: #{Application.get_env(:server_utils, :max_number_of_items)}}

      iex> #{__MODULE__}.parse_cursor_page_request(%{"cursor": "", "number_of_items": 0})
      %ServerUtils.Pagination.Cursor.PageRequest{cursor: "", number_of_items: #{
    @default_number_of_items
  }}

      iex> #{__MODULE__}.parse_cursor_page_request(%{"number_of_items": 0}, cursor: "a_default_cursor")
      %ServerUtils.Pagination.Cursor.PageRequest{cursor: "a_default_cursor", number_of_items: #{
    @default_number_of_items
  }}
  """
  @spec parse_cursor_page_request(map(), default_values_opts()) :: CursorPageRequest.t()
  def parse_cursor_page_request(params_map, opts \\ []) do
    default_cursor =
      opts[:cursor] || Application.get_env(:server_utils, :default_cursor) || @default_cursor

    default_number_of_items =
      opts[:number_of_items] || Application.get_env(:server_utils, :default_number_of_items) ||
        @default_number_of_items

    max_number_of_items =
      opts[:max_number_of_items] || Application.get_env(:server_utils, :max_number_of_items) ||
        @default_max_number_of_items

    number_of_items =
      Pagination.get_non_neg_param_value_with_max_limit(
        params_map,
        @page_number_of_items_key,
        max_number_of_items,
        default_number_of_items
      )

    cursor = Map.get(params_map, @cursor_key, default_cursor)

    %PageRequest{cursor: cursor, number_of_items: number_of_items}
  end
end
