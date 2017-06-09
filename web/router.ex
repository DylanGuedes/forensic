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

    resources "/stages", StageController
    get "/", PageController, :index
    get "/alerts", AlertController, :index
    get "/streams/flush/:id", StreamController, :flush
    get "/streams/:id/:stage_id/params", StreamController, :edit_params
    post "/stages/:id/create_mirror_param", StageController, :create_mirror_param
    post "/streams/:id/:stage_id/:param_id/configure_param", StreamController, :configure_param
    get "/streams/:id/shock_injection", StreamController, :shock_injection
    get "/streams/:id/stream_creation", StreamController, :stream_creation
    get "/streams/:id/start_streaming", StreamController, :start_streaming
    get "/streams/:id/delete", StreamController, :delete
    get "/stages/:id/:param_id", StageController, :remove_param
    resources "/changelog", ChangelogController
    resources "/streams", StreamController
    resources "/mirror_params", MirrorParamController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Forensic do
  #   pipe_through :api
  # end
end
