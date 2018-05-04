defmodule ServerUtils.Parsers.Pagination.Classic.Parser do
  @moduledoc """
  Module to get an `integer()` or a `PageParams.t` struct from a request map.

  In case of page params parse, it validates the maximum page size request and provides the configured maximum param if it is exceeded.

  This project provides a default value, but they can be overriding when using this module as well.
  """

  alias ServerUtils.Pagination.Classic.PageRequest

  alias ServerUtils.Parsers.Params.ParamGetter
  alias ServerUtils.Parsers.Pagination

  @page_size_key Application.get_env(:server_utils, :page_size_key) || "page_size"
  @page_number_key Application.get_env(:server_utils, :page_number_key) || "page_number"

  @default_page_number 1
  @default_page_size 25
  @default_max_page_size 100

  @doc """
  Parses a page params from a request params map.

  It returns the `PageParams.t` with the given values.

  If the given page size exceeds the maxim page size or equal or less than 0, then the default value is returned

  ## Examples

      iex> #{__MODULE__}.parse_page_params(%{"page_number" => 5, "page_size" => 23})
      %ServerUtils.Pagination.Classic.PageRequest{page_number: 5, page_size: 23}

      # With a configured max_page_size of 50
      iex> #{__MODULE__}.parse_page_params(%{"page_number" => 5, "page_size" => 9000})
      %ServerUtils.Pagination.Classic.PageRequest{page_number: 5,
        page_size: #{Application.get_env(:server_utils, :max_page_size)}
      }

      iex> #{__MODULE__}.parse_page_params(%{"page_number" => 5, "page_size" => 0})
      %ServerUtils.Pagination.Classic.PageRequest{page_number: 5, page_size: #{
    Application.get_env(:server_utils, :page_size)
  }}
  """
  @spec parse_page_params(map()) :: PageRequest.t()
  def parse_page_params(params_map, opts \\ []) do
    default_page_number =
      opts[:page_number] || Application.get_env(:server_utils, :page_number) ||
        @default_page_number

    default_page_size =
      opts[:page_size] || Application.get_env(:server_utils, :page_size) || @default_page_size

    max_page_size =
      opts[:max_page_size] || Application.get_env(:server_utils, :max_page_size) ||
        @default_max_page_size

    page_number = ParamGetter.get_integer_param(params_map, @page_number_key, default_page_number)

    page_size =
      Pagination.get_non_neg_param_value_with_max_limit(
        params_map,
        @page_size_key,
        max_page_size,
        default_page_size
      )

    %PageRequest{page_size: page_size, page_number: page_number}
  end
end
