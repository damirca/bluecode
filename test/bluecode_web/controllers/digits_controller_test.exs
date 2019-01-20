defmodule BluecodeWeb.DigitsControllerTest do
  use BluecodeWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "stores new digits", %{conn: conn} do
      conn = post(conn, Routes.digits_path(conn, :create), digits: [1, 2, 3])

      assert json_response(conn, 201)["digits"] == [1, 2, 3]
    end

    test "returns a proper error when input is invalid", %{conn: conn} do
      conn = post(conn, Routes.digits_path(conn, :create), digits: [1, "foo", 3])

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
      Bluecode.DigitsHandler.store([1, 2, 3])

      :ok
    end

    test "returns checksum of the stored digits", %{conn: conn} do
      conn = get(conn, Routes.digits_checksum_path(conn, :checksum))
      assert json_response(conn, 200)["checksum"] == 6
    end
  end
end
