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

    resources "/stages", StageController do
      resources "/mirror_params", MirrorParamController, only: [:create, :edit, :update]
      get "/mirror_param/:id/delete", MirrorParamController, :delete
    end

    get "/streams/flush", StreamController, :flush
    get "/avg", AlertController, :avg
    get "/flush_avg", AlertController, :flush_avg

    get "/", PageController, :index
    resources "/alerts", AlertController, only: [:index]
    get "/streams/:id/shock_injection", StreamController, :shock_injection
    get "/streams/:id/stream_creation", StreamController, :stream_creation
    get "/streams/:id/start_streaming", StreamController, :start_streaming
    get "/streams/:id/delete", StreamController, :delete

    resources "/changelog", ChangelogController

    resources "/streams", StreamController do
      resources "/stage_params", StageParamController, only: [:update]
      get "/stages/:stage_id/stage_params", StageParamController, :index
      post "/mirror_params/:mirror_param_id", StageParamController, :create
      get "/stage_param/:id/delete", StageParamController, :delete
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", Forensic do
  #   pipe_through :api
  # end
end
