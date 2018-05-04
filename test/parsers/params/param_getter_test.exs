defmodule ServerUtils.Parsers.Params.ParamGetterTest do
  @moduledoc false
  @moduletag [:pagination, :cursor]

  use ExUnit.Case

  doctest ServerUtils.Parsers.Params.ParamGetter

  alias ServerUtils.Parsers.Params.ParamGetter

  describe "Given a params map" do
    test "when given a param key that represents a integer then the integer value is returned" do
      expected_value = 23

      result = ParamGetter.get_integer_param(%{a: expected_value}, :a, 0)

      assert expected_value == result
    end

    test "when given a param key that represents a integer and use get_integer_param! then the integer value is returned" do
      expected_value = 23

      result = ParamGetter.get_integer_param!(%{a: expected_value}, :a)

      assert expected_value == result

      result = ParamGetter.get_integer_param!(%{a: to_string(expected_value)}, :a)

      assert expected_value == result
    end

    test "when given a param key that represents a integer that does not exist and use get_integer_param! then an exception is raised" do
      assert_raise ServerUtils.Parsers.Params.ParamError, fn ->
        ParamGetter.get_integer_param!(%{a: 10}, :b)
      end
    end

    test "when given a param key that represents a string then the integer value is returned" do
      expected_value = 23
      result = ParamGetter.get_integer_param(%{a: to_string(expected_value)}, :a, 0)

      assert expected_value == result
    end

    test "when given a param key that does not exist then the default value is returned" do
      expected_value = 0

      result = ParamGetter.get_integer_param(%{b: to_string(23)}, :a, expected_value)

      assert expected_value == result
    end
  end
end
