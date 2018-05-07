defmodule ServerUtils.SentryLogger do
  @moduledoc """
    Logger wrapper that handles `warn` and `error` logging and sends a Sentry report. Both logging and Sentry calls will be executed asynchronously.

    Sentry will need to be configured in the project that uses this dependency.

    The integration with Sentry can be disabled by setting the system variable *DISABLE_SENTRY* as true.
  """

  require Logger

  @doc """
  Logs a debug message.

  Returns `:ok` or an `{:error, reason}` tuple.
  """
  @spec debug(String.t()) :: atom()
  def debug(message) do
    Logger.debug(fn -> message end)
  end

  @doc """
  Logs a info message.

  Returns `:ok` or an `{:error, reason}` tuple.
  """
  @spec info(String.t()) :: atom()
  def info(message) do
    Logger.info(fn -> message end)
  end

  @doc """
  Logs a warn message.

  Unless the system variable `DISABLE_SENTRY` is set, it will send the logged message as warning level to Sentry.

  Returns `:ok` or an `{:error, reason}` tuple.

  Returns a [Task](https://hexdocs.pm/elixir/Task.html#content) struct is Sentry is **enabled**.
  """
  @spec warn(String.t()) :: atom() | Task.t()
  def warn(message) do
    if System.get_env("DISABLE_SENTRY") do
      Logger.warn(fn -> message end)
    else
      opts = [
        environment: System.get_env("ENVIRONMENT"),
        level: "warning"
      ]

      Logger.warn(fn -> message end)

      Task.start(fn -> Sentry.capture_message(message, opts) end)
    end
  end

  @doc """
  Logs a error message.

  Unless the system variable `DISABLE_SENTRY` is set, it will send the logged message as error level to Sentry.

  Returns `:ok` or an `{:error, reason}` tuple if Sentry is **disabled**.

  Returns a [Task](https://hexdocs.pm/elixir/Task.html#content) struct is Sentry is **enabled**.
  """
  @spec error(String.t()) :: atom() | Task.t()
  def error(message) do
    if System.get_env("DISABLE_SENTRY") do
      Logger.error(fn -> message end)
    else
      opts = [
        environment: System.get_env("ENVIRONMENT"),
        level: "error"
      ]

      Logger.error(fn -> message end)

      Task.start(fn -> Sentry.capture_message(message, opts) end)
    end
  end
end
