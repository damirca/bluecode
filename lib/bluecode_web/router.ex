defmodule BluecodeWeb.Router do
  use BluecodeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BluecodeWeb do
    pipe_through :api

    resources "/digits", DigitsController, only: [:create, :delete], singleton: true do
      get "/checksum", DigitsController, :checksum, as: :checksum
    end
  end
end
