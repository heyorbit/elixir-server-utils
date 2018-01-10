defmodule ServerUtils.Parsers.ParamsParserTest do
  @moduledoc false

  use ExUnit.Case

  alias ServerUtils.Parsers.ParamsParser
  alias ServerUtils.Page.PageParams

  @moduletag :unit

  test "Given a params map when parse the params then a PageParams is returned" do
    expected_value = %PageParams{page_number: 23, page_size: 5}

    result = ParamsParser.parse_page_params(%{"page_size" => "5", "page_number" => "23"})

    assert expected_value == result
  end

  test "Given a params map when the page size is more than the maximum allowed then a PageParams with the max page size is returned" do
    default_max_page_size = Application.get_env(:server_utils, :max_page_size)
    expected_value = %PageParams{page_number: 23, page_size: default_max_page_size}

    result = ParamsParser.parse_page_params(%{"page_size" => 500_000, "page_number" => 23})

    assert expected_value == result
  end

  test "Given a params map and a param name when the param is a integer then the integer value is returned" do
    expected_value = 23

    result = ParamsParser.parse_integer_param(%{a: expected_value}, :a, 0)

    assert expected_value == result
  end

  test "Given a params map and a param name when the param is a string then the integer value is returned" do
    expected_value = 23
    result = ParamsParser.parse_integer_param(%{a: to_string(expected_value)}, :a, 0)

    assert expected_value == result
  end

  test "Given a params map and a param name when the param does not exist then the default value is returned" do
    expected_value = 0

    result = ParamsParser.parse_integer_param(%{b: to_string(23)}, :a, expected_value)

    assert expected_value == result
  end
end
