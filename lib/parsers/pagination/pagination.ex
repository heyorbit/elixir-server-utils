defmodule ServerUtils.Parsers.Pagination do
  @moduledoc false

  alias ServerUtils.Parsers.Params.ParamGetter

  @doc """
  Receives a key, a default value and a maximum value.

  This function gets a non neg value from a map:
    * If the value is not present or is not a valid integer, the default value is returned
    * If the value is negative, the default value is returned
    * If the value exceeds the maximum value, the maximum value is returned
    * Otherwise, the value is returned

  iex> #{__MODULE__}.get_non_neg_param_value_with_max_limit(%{}, "luke", 15, 10)
  10

  iex> #{__MODULE__}.get_non_neg_param_value_with_max_limit(%{}, "luke", 5, 10)
  5

  iex> #{__MODULE__}.get_non_neg_param_value_with_max_limit(%{"luke" => 23}, "luke", 5, 10)
  5

  iex> #{__MODULE__}.get_non_neg_param_value_with_max_limit(%{"luke" => 23}, "luke", 25, 10)
  23

  iex> #{__MODULE__}.get_non_neg_param_value_with_max_limit(%{luke: 23}, :luke, 25, 10)
  23
  """
  @spec get_non_neg_param_value_with_max_limit(
          map(),
          String.t(),
          non_neg_integer,
          non_neg_integer
        ) :: non_neg_integer
  def get_non_neg_param_value_with_max_limit(params_map, param_key, max_value, default_value) do
    case ParamGetter.get_integer_param(params_map, param_key, default_value) do
      param_value when param_value > max_value ->
        max_value

      param_value when param_value <= 0 ->
        default_value

      param_value ->
        param_value
    end
  end
end
