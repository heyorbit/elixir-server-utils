defmodule ServerUtils.Parsers.Params.ParamGetter do
  @moduledoc false

  alias ServerUtils.Parsers.IntegerParser
  alias ServerUtils.Parsers.Params.ParamError

  @doc """
  Parses a integer value from a request params map.

  It returns the `integer()` with the parsed value or the default value if the param key is not present or is not an integer.

  ## Examples

      iex> #{__MODULE__}.get_integer_param(%{a: 5}, :a, 10)
      5

      iex> #{__MODULE__}.get_integer_param(%{a: 5}, :b, 10)
      10

  """
  @spec get_integer_param(map(), String.t(), integer()) :: integer()
  def get_integer_param(params_map, attr_name, default) do
    case Map.get(params_map, attr_name, default) do
      value when is_integer(value) -> value
      value -> IntegerParser.parse_integer(value, default)
    end
  end

  @spec get_integer_param!(map(), String.t()) :: integer()
  def get_integer_param!(params_map, attr_name) do
    case Map.get(params_map, attr_name) do
      nil -> raise ParamError, message: "Param not found"
      value when is_integer(value) -> value
      value -> IntegerParser.parse_integer!(value)
    end
  end
end
