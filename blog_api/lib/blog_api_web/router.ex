defmodule BlogApiWeb.Router do
  use BlogApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BlogApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    # plug Corsica, origins: "*", allow_headers: ~w(accept content-type authorization)
    plug CORSPlug, origin: "*", headers: ~w(accept content-type authorization)
    plug BlogApiWeb.Context
  end

  # scope "/", BlogApiWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  scope "/" do
    pipe_through :graphql

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BlogApiWeb.Schema,
      interface: :advanced,
      context: %{pubsub: BlogApiWeb.Endpoint},
      socket: BlogApiWeb.UserSocket

    forward "/graphql", Absinthe.Plug,
      schema: BlogApiWeb.Schema,
      context: %{pubsub: BlogApiWeb.Endpoint},
      socket: BlogApiWeb.UserSocket
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogApiWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:blog_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BlogApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
