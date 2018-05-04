defmodule ServerUtils.Pagination.Cursor.PageInfo do
  @moduledoc """
  Moule that represents a cursor pagination
  """

  @type t :: %__MODULE__{
          has_next_page: boolean(),
          end_cursor: String.t()
        }

  @enforce_keys [:has_next_page, :end_cursor]

  defstruct @enforce_keys
end
