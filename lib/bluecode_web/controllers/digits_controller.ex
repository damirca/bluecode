defmodule BluecodeWeb.DigitsController do
  use BluecodeWeb, :controller

  alias Bluecode.DigitsHandler

  def create(conn, %{"digits" => digits}) when is_list(digits) do
    case DigitsHandler.store(digits) do
      {:ok, digits} ->
        conn
        |> put_status(:created)
        |> render("digits.json", digits: digits)
      {:error, :invalid_input} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(422, build_json_error("Invalid input"))
    end
  end

  def create(conn, _params) do
    send_resp(conn, 422, build_json_error("Invalid input"))
  end

  def delete(conn, _params) do
    DigitsHandler.clear()

    conn
    |> put_status(:no_content)
    |> send_resp(204, "")
  end

  def checksum(conn, _params) do
    case DigitsHandler.checksum() do
      {:ok, checksum} ->
        conn
        |> put_status(:ok)
        |> render("checksum.json", checksum: checksum)
      {:error, :no_stored_input} ->
        conn
        |> send_resp(500, build_json_error("No digits stored"))
      {:error, :timeout} ->
        conn
        |> send_resp(504, build_json_error("The calculation timed out"))
      {:error, reason} ->
        conn
        |> send_resp(500, build_json_error(inspect(reason)))
    end
  end

  defp build_json_error(error) do
    Jason.encode!(%{error: error})
  end
end
