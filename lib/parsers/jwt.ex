defmodule ServerUtils.Parsers.Jwt do
  @moduledoc """
  JWT parser to get claim values.
  """

  import Joken

  @doc """
  Gets a claim value using the claim key from a JWT. Optional this call can fail if `error_if_blank` is provided.

  ## Examples

      iex> #{__MODULE__}.get_claim("example_jwt", "username")
      {:ok, "luke"}

      iex> #{__MODULE__}.get_claim("example_jwt", "username")
      {:ok, ""}

      iex> #{__MODULE__}.get_claim("example_jwt", "username", error_if_blank: true)
      {:error, "Blank claim username"}

  """
  @spec get_claim(String.t(), String.t(), Keyword.t()) :: {atom(), String.t()}
  def get_claim(jwt, claim_key, opts \\ [error_if_blank: false]) do
    jwt
    |> token()
    |> peek()
    |> get_decoded_claim(claim_key, opts)
  end

  @doc false
  @spec get_decoded_claim(map(), String.t(), Keyword.t()) :: {atom(), String.t()}
  defp get_decoded_claim(claims, claim_key, opts) do
    case Map.get(claims, claim_key) do
      nil ->
        {:error, "Cannot get claim #{claim_key}"}

      claim ->
        if claim == "" && opts[:error_if_blank] do
          {:error, "Blank claim #{claim_key}"}
        else
          {:ok, claim}
        end
    end
  end
end
