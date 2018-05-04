defmodule ServerUtils.Parsers.ParamsParserTest do
  @moduledoc false
  @moduletag [:unit]

  use ExUnit.Case

  doctest ServerUtils.Parsers.Pagination.Classic.Parser

  alias ServerUtils.Parsers.Pagination.Classic.Parser

  alias ServerUtils.Pagination.Classic.PageRequest

  describe "Given a params map" do
    test "when parse the params then a PageParams is returned" do
      expected_value = %PageRequest{page_number: 23, page_size: 5}

      result = Parser.parse_page_params(%{"page_size" => "5", "page_number" => "23"})

      assert expected_value == result
    end

    test "when the page size is more than the maximum allowed then a PageParams with the max page size is returned" do
      default_max_page_size = Application.get_env(:server_utils, :max_page_size)
      expected_value = %PageRequest{page_number: 23, page_size: default_max_page_size}

      result = Parser.parse_page_params(%{"page_size" => 500_000, "page_number" => 23})

      assert expected_value == result
    end
  end
end
