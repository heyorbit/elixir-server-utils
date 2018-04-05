defmodule ParamException do
  @type t :: %__MODULE__{message: String.t()}
  defexception [:message]
end

defmodule ServerUtils.Parsers.ParamsParser do
  @moduledoc """
  Module to get an `integer()` or a `PageParams.t` struct from a request map.

  In case of page params parse, it validates the maximum page size request and provides the configured maximum param if it is exceeded.

  This project provides a default value, but they can be overriding when using this module as well.
  """

  alias ServerUtils.Parsers.IntegerParser
  alias ServerUtils.Page.PageParams
  alias ServerUtils.Page.CursorPageRequest

  @page_size_key Application.get_env(:server_utils, :page_size_key) || "page_size"
  @page_number_key Application.get_env(:server_utils, :page_number_key) || "page_number"

  @default_page_number 1
  @default_page_size 25
  @default_max_page_size 100

  @cursor_key Application.get_env(:server_utils, :cursor_key) || "cursor"
  @page_number_of_items_key Application.get_env(:server_utils, :number_of_items) ||
                              "number_of_items"

  @default_cursor ""
  @default_number_of_items 25

  @doc """
  Parses a page params from a request params map.

  It returns the `PageParams.t` with the present values and with the default.

  ## Examples

      iex> ServerUtils.Parsers.ParamsParser.parse_page_params!(%{"page_number": 5, "page_size": 23})
      %PageParams{page_number: 5, page_size: 23}

      # With a configured max_page_size of 50
      iex> ServerUtils.Parsers.ParamsParser.parse_page_params!(%{"page_number": 5, "page_size": 9000})
      %PageParams{page_number: 5, page_size: 50}

  """
  @spec parse_page_params(map()) :: PageParams.t()
  def parse_page_params(params_map, opts \\ []) do
    default_page_number =
      opts[:page_number] || Application.get_env(:server_utils, :page_number) ||
        @default_page_number

    default_page_size =
      opts[:page_size] || Application.get_env(:server_utils, :page_size) || @default_page_size

    max_page_size =
      opts[:max_page_size] || Application.get_env(:server_utils, :max_page_size) ||
        @default_max_page_size

    page_number = parse_integer_param(params_map, @page_number_key, default_page_number)

    page_size =
      case parse_integer_param(params_map, @page_size_key, default_page_size) do
        page_size when page_size > max_page_size ->
          max_page_size

        page_size ->
          page_size
      end

    %PageParams{page_size: page_size, page_number: page_number}
  end

  @doc """
  Parses a page params from a cursor pagination request.

  It returns the `CursorPageRequest.t` with the present values and with the default.

  ## Examples

      iex> ServerUtils.Parsers.ParamsParser.parse_cursor_page_request!(%{"page_number": 5, "page_size": 23})
      %PageParams{page_number: 5, page_size: 23}

      # With a configured max_page_size of 50
      iex> ServerUtils.Parsers.ParamsParser.parse_cursor_page_request!(%{"page_number": 5, "page_size": 9000})
      %PageParams{page_number: 5, page_size: 50}

  """
  @spec parse_cursor_page_request(map()) :: CursorPageRequest.t()
  def parse_cursor_page_request(params_map, opts \\ []) do
    default_cursor =
      opts[:cursor] || Application.get_env(:server_utils, :default_cursor) || @default_cursor

    default_number_of_items =
      opts[:number_of_items] || Application.get_env(:server_utils, :default_number_of_items) ||
        @default_number_of_items

    max_number_of_items =
      opts[:max_page_size] || Application.get_env(:server_utils, :max_number_of_items) ||
        @default_max_page_size

    number_of_items =
      case parse_integer_param(params_map, @page_number_of_items_key, default_number_of_items) do
        number_of_items when number_of_items > max_number_of_items ->
          max_number_of_items

        number_of_items ->
          number_of_items
      end

    cursor = Map.get(params_map, @cursor_key, default_cursor)

    %CursorPageRequest{cursor: cursor, number_of_items: number_of_items}
  end

  @doc """
  Parses a integer value from a request params map.

  It returns the `integer()` with the parsed value or the default value if the param key is not present or is not an integer.

  ## Examples

      iex> ServerUtils.Parsers.ParamsParser.parse_integer_param(%{a: 5}, :a, 10)
      5

      iex> ServerUtils.Parsers.ParamsParser.parse_integer_param(%{a: 5}, :b, 10)
      10

  """
  @spec parse_integer_param(map(), String.t(), integer()) :: integer()
  def parse_integer_param(params_map, attr_name, default) do
    case Map.get(params_map, attr_name, default) do
      value when is_integer(value) -> value
      value -> IntegerParser.parse_integer(value, default)
    end
  end

  @spec parse_integer_param!(map(), String.t()) :: integer()
  def parse_integer_param!(params_map, attr_name) do
    case Map.get(params_map, attr_name) do
      nil -> raise ParamException, message: "Param not found"
      value when is_integer(value) -> value
      value -> IntegerParser.parse_integer!(value)
    end
  end
end
