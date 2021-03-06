defmodule ServerUtils.Pagination.Cursor.PageRequest do
  @moduledoc """
  Defines a page request for cursor pagination
  """

  @typedoc """
  Values:
  - cursor: The cursor to get items from
  - number_of_items: number of items to retrieve
  """
  @type t :: %__MODULE__{
          cursor: String.t(),
          number_of_items: non_neg_integer()
        }

  defstruct [:cursor, :number_of_items]
end
