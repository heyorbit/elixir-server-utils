defmodule ServerUtils.Parsers.IntegerParserTest do
  @moduledoc false

  use ExUnit.Case

  alias ServerUtils.Parsers.IntegerParser

  @moduletag :unit

  test "Given an integer when parse it then the integer value is returned" do
    expected_value = 23
    result = IntegerParser.parse_integer(23, 100)

    assert expected_value == result
  end

  test "Given a string representation of an integer when parse it then the integer value is returned" do
    expected_value = 23
    result = IntegerParser.parse_integer("23", 100)

    assert expected_value == result
  end

  test "Given a string that is not a representation of an integer and a default integer value when parse it then the default value is returned" do
    default_value = 13
    result = IntegerParser.parse_integer("aa", default_value)

    assert default_value == result
  end

  test "Given a string representation of an integer when parse! it then the integer value is returned" do
    expected_value = 7
    result = IntegerParser.parse_integer!("7")

    assert expected_value == result
  end

  test "Given an integer when parse! it then the integer value is returned" do
    expected_value = 7
    result = IntegerParser.parse_integer!(7)

    assert expected_value == result
  end

  test "Given a string that is not a representation of an integer when parse! it then an exception is thrown" do
    invalid_value = "zzzz"

    assert_raise RuntimeError, "Invalid integer: #{inspect(invalid_value)}", fn ->
      IntegerParser.parse_integer!(invalid_value)
    end
  end
end
