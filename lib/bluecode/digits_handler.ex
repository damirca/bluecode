defmodule Bluecode.DigitsHandler do
  use GenServer
  require Integer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :digits_handler)
  end

  def init(:ok) do
    {:ok, []}
  end

  def store(digits) do
    GenServer.call(:digits_handler, {:store, digits})
  end

  def clear do
    GenServer.call(:digits_handler, :clear)
  end

  def checksum do
    GenServer.call(:digits_handler, :checksum)
  end

  def handle_call({:store, digits}, _from, state) when is_list(digits) do
    if valid_input?(digits) do
      new_state = List.flatten([state | digits])

      {:reply, {:ok, new_state}, new_state}
    else
      {:reply, {:error, :invalid_input}, state}
    end
  end

  def handle_call({:store, _input}, _from, state) do
    {:reply, {:error, :invalid_input}, state}
  end

  def handle_call(:checksum, _from, [] = state) do
    {:reply, {:error, :no_stored_input}, state}
  end

  # `Task.async` links a task process with the parent one meaning that if
  # task crashes, DigitsHandler would also crash. In order to avoid that
  # I use try-rescue.
  def handle_call(:checksum, _from, state) do
    task =
      Task.async fn ->
        try do
          calculate_checksum(state)
        rescue
          e -> e
        end
      end

    case Task.yield(task, 15_000) || Task.shutdown(task) do
      nil ->
        {:reply, {:error, :timeout}, state}
      {:exit, reason} ->
        {:reply, {:error, reason}, state}
      {:error, reason} ->
        {:reply, {:error, reason}, state}
      {:ok, checksum} when is_integer(checksum) ->
        {:reply, {:ok, checksum}, state}
      {:ok, other} ->
        {:reply, {:error, other}, state}
    end
  end

  def handle_call(:clear, _from, _state) do
    {:reply, {:ok, []}, []}
  end

  defp calculate_checksum(digits) do
    {odd, even} =
      digits
      |> Stream.with_index(1)
      |> Enum.reduce({[], []}, fn({digit, index}, {odd, even}) ->
        if Integer.is_even(index) do
          {odd, [digit | even]}
        else
          {[digit | odd], even}
        end
      end)

    odd_sum = Enum.sum(odd) * 3
    even_sum = Enum.sum(even)

    remainder = rem(even_sum + odd_sum, 10)

    if remainder == 0 do
      0
    else
      10 - remainder
    end
  end

  defp valid_input?(input) do
    input
    |> Stream.map(&to_string/1)
    |> Enum.all?(&is_digit?/1)
  end

  # Detect a digit by its ascii code.
  defp is_digit?(<<value::utf8>>) when value >= 48 and value < 59 do
    true
  end
  defp is_digit?(_), do: false
end
