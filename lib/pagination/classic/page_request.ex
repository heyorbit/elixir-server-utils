defmodule ServerUtils.Pagination.Classic.PageRequest do
  @moduledoc """
  Structure that represents a page request with the page information and the page size
  """

  @typedoc """
  Integer values for page number and page size
  """
  @type t :: %__MODULE__{
          page_number: non_neg_integer(),
          page_size: non_neg_integer()
        }

  defstruct [:page_number, :page_size]
end
