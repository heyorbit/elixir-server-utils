defmodule ServerUtils.Parsers.IntegerParser do
  @moduledoc """
  Module to simplify the parsing of an Integer value.

  It provides a bang! function that will raise an error if the parsing failed.
  """

  @doc """
  Parses an integer value.

  It returns the integer value or throws an error if something failed.

  ## Examples

      iex> ServerUtils.Parsers.IntegerParser.parse_integer!("23")
      23

      iex> ServerUtils.Parsers.IntegerParser.parse_integer!(23)
      23

      iex> ServerUtils.Parsers.IntegerParser.parse_integer!("abc")
      ** (RuntimeError) "Invalid integer: abc"

  """
  @spec parse_integer!(String.t) :: Integer.t
  def parse_integer!(value) when is_integer(value), do: value
  def parse_integer!(value) do
    case Integer.parse(value) do
      :error -> raise "Invalid integer: #{inspect value}"
      {value, _} -> value
    end
  end


  @doc """
  Parses an integer value.

  It returns the integer value if succeed or the default value if something failed.

  ## Examples

      iex> ServerUtils.Parsers.IntegerParser.parse_integer("23", 15)
      23

      iex> ServerUtils.Parsers.IntegerParser.parse_integer(23, 7)
      23

      iex> ServerUtils.Parsers.IntegerParser.parse_integer("abc", 5)
      5

  """
  @spec parse_integer(String.t, Integer.t) :: Integer.t
  def parse_integer(value, _default) when is_integer(value), do: value
  def parse_integer(value, default) do
    case Integer.parse(value) do
      :error -> default
      {value, _} -> value
    end
  end

end
