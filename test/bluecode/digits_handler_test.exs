defmodule Bluecode.DigitsHandlerTest do
  use ExUnit.Case, async: true

  alias Bluecode.DigitsHandler

  setup do
    DigitsHandler.clear()

    :ok
  end

  describe "store" do
    test "store digits" do
      assert DigitsHandler.store("01239") == {:ok, [0, 1, 2, 3, 9]}
    end

    test "fail to store when input contains non-digit symbol" do
      assert DigitsHandler.store("12foo") == {:error, :invalid_input}
    end

    test "fail to store when input is a list" do
      assert DigitsHandler.store(["1"]) == {:error, :invalid_input}
    end

    test "fail to store when input contains a float" do
      assert DigitsHandler.store("10.1") == {:error, :invalid_input}
    end
  end

  describe "clear" do
    setup do
      DigitsHandler.store("12")

      :ok
    end

    test "clear stored digits" do
      assert DigitsHandler.clear() == {:ok, []}
    end
  end

  describe "checksum" do
    test "calculte checksum" do
      DigitsHandler.store("123")

      assert DigitsHandler.checksum() == {:ok, 6}
    end

    test "calculate checksum with input from the readme" do
      DigitsHandler.store("5489850354")

      assert DigitsHandler.checksum() == {:ok, 7}
    end

    test "calculte checksum after adding more digits" do
      DigitsHandler.store("123")
      DigitsHandler.store("122")

      assert DigitsHandler.checksum() == {:ok, 7}
    end
  end
end
