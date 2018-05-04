defmodule ServerUtils.Parsers.Params.ParamError do
  @type t :: %__MODULE__{message: String.t()}
  defexception [:message]
end
