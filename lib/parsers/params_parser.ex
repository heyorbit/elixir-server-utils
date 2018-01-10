defmodule ServerUtils.Parsers.ParamsParser do
  @moduledoc """
  Module to get an `Integer.t` or a `PageParams.t` struct from a request map.

  In case of page params parse, it validates the maximum page size request and provides the configured maximum param if it is exceeded.

  This project provides a default value, but they can be overriding when using this module as well.
  """

  alias ServerUtils.Parsers.IntegerParser
  alias ServerUtils.Page.PageParams

  @page_size_key Application.get_env(:server_utils, :page_size_key) || "page_size"
  @page_number_key Application.get_env(:server_utils, :page_number_key) || "page_number"

  @default_page_number 1
  @default_page_size 25
  @default_max_page_size 100

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
  @spec parse_page_params(Map.t) :: PageParams.t
  def parse_page_params(params_map, opts \\ []) do
    default_page_number = opts[:page_number] || Application.get_env(:server_utils, :page_number) || @default_page_number
    default_page_size = opts[:page_size] || Application.get_env(:server_utils, :page_size) || @default_page_size
    max_page_size = opts[:max_page_size] || Application.get_env(:server_utils, :max_page_size) || @default_max_page_size

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
  Parses a integer value from a request params map.

  It returns the `Integer.t` with the parsed value or the default value if the param key is not present or is not an integer.

  ## Examples

      iex> ServerUtils.Parsers.ParamsParser.parse_integer_param(%{a: 5}, :a, 10)
      5

      iex> ServerUtils.Parsers.ParamsParser.parse_integer_param(%{a: 5}, :b, 10)
      10

  """
  @spec parse_integer_param(Map.t, String.t, Integer.t) :: Integer.t
  def parse_integer_param(params_map, attr_name, default) do
    case Map.get(params_map, attr_name, default) do
      value when is_integer(value) -> value
      value -> IntegerParser.parse_integer(value, default)
    end
  end

end
