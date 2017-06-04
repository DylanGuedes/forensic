defmodule Forensic.Router do
  use Forensic.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Forensic do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/alerts", AlertController, :index
    get "/streams/flush/:id", StreamController, :flush
    resources "/changelog", ChangelogController
    resources "/streams", StreamController
    resources "/stages", StageController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Forensic do
  #   pipe_through :api
  # end
end
