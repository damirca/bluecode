defmodule Bluecode.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BluecodeWeb.Endpoint,
      Bluecode.DigitsHandler
    ]

    opts = [strategy: :one_for_one, name: Bluecode.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BluecodeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
