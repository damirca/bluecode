defmodule BluecodeWeb.Router do
  use BluecodeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BluecodeWeb do
    pipe_through :api
  end
end
