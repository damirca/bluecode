defmodule Bluecode.DigitsHandlerTest do
  use ExUnit.Case, async: true

  alias Bluecode.DigitsHandler

  setup do
    DigitsHandler.clear()

    :ok
  end

  describe "store" do
    test "store digits" do
      assert DigitsHandler.store([0, 1, 2, 3, 9]) == {:ok, [0, 1, 2, 3, 9]}
    end

    test "fail to store when input contains a binary" do
      assert DigitsHandler.store([1, 2, "foo"]) == {:error, :invalid_input}
    end

    test "fail to store when input is not a list" do
      assert DigitsHandler.store(1) == {:error, :invalid_input}
    end

    test "fail to store when input contains a number" do
      assert DigitsHandler.store([1, 10]) == {:error, :invalid_input}
    end

    test "fail to store when input contains a float" do
      assert DigitsHandler.store([1, 10.0]) == {:error, :invalid_input}
    end
  end

  describe "clear" do
    setup do
      DigitsHandler.store([1, 2])

      :ok
    end

    test "clear stored digits" do
      assert DigitsHandler.clear() == {:ok, []}
    end
  end

  describe "checksum" do
    test "calculte checksum" do
      DigitsHandler.store([1, 2, 3])

      assert DigitsHandler.checksum() == {:ok, 6}
    end

    test "calculate checksum with input from the readme" do
      DigitsHandler.store([5, 4, 8, 9, 8, 5, 0, 3, 5, 4])

      assert DigitsHandler.checksum() == {:ok, 7}
    end

    test "calculte checksum after adding more digits" do
      DigitsHandler.store([1, 2, 3])
      DigitsHandler.store([1, 2, 2])

      assert DigitsHandler.checksum() == {:ok, 7}
    end
  end
end
