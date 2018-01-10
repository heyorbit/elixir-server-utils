defmodule ServerUtils.LoggerTest do
  @moduledoc false

  use ExUnit.Case, async: false

  import ExUnit.CaptureLog
  import Mock

  alias ServerUtils.Logger

  describe "Given a message" do
    setup _ do
      System.put_env("DISABLE_SENTRY", "true")
      on_exit fn -> System.delete_env("DISABLE_SENTRY") end
    end

    test "when debug then the logger debug is called" do
      message = "this is a debug message"

      assert capture_log(fn ->
        Logger.debug(message)
      end) =~ message
    end

    test "when info then the logger info is called" do
      message = "this is a info message"

      assert capture_log(fn ->
        Logger.info(message)
      end) =~ message
    end

    test "when warn then the logger warn is called" do
      message = "this is a warn message"

      assert capture_log(fn ->
        Logger.warn(message)
      end) =~ message
    end

    test "when error then the logger error is called" do
      message = "this is a error message"

      assert capture_log(fn ->
        Logger.error(message)
      end) =~ message
    end
  end

  describe "When Sentry is enabled" do
    test "then the warn messages are captured" do
      with_mock Sentry, [capture_message: fn message, _opts -> send :test, {message} end] do

        capture_log(fn ->
          Process.register self(), :test

          Logger.warn("this is a error message")

          assert_receive {"this is a error message"}, 500
        end)
      end
    end

    test "then the error messages are captured" do
      with_mock Sentry, [capture_message: fn message, _opts -> send :test, {message} end] do

        capture_log(fn ->
          Process.register self(), :test

          Logger.error("this is a error message")

          assert_receive {"this is a error message"}, 500
        end)
      end
    end
  end

end
