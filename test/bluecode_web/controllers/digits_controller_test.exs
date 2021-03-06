defmodule BluecodeWeb.DigitsControllerTest do
  use BluecodeWeb.ConnCase

  alias Bluecode.DigitsHandler

  setup %{conn: conn} do
    DigitsHandler.clear()

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "stores new digits", %{conn: conn} do
      conn = post(conn, Routes.digits_path(conn, :create), digits: "123")

      assert json_response(conn, 201)["digits"] == [1, 2, 3]
    end

    test "returns a proper error when input is invalid", %{conn: conn} do
      conn = post(conn, Routes.digits_path(conn, :create), digits: "1foo3")

      assert json_response(conn, 422)["error"] == "Invalid input"
    end
  end

  describe "delete" do
    test "clears the stored digits", %{conn: conn} do
      conn = delete(conn, Routes.digits_path(conn, :delete))
      assert response(conn, 204)
    end
  end

  describe "checksum" do
    setup do
      DigitsHandler.store("123")

      :ok
    end

    test "returns checksum of the stored digits", %{conn: conn} do
      conn = get(conn, Routes.digits_checksum_path(conn, :checksum))
      assert json_response(conn, 200)["checksum"] == 6
    end
  end
end
