defmodule MultiTenancexWeb.Router do
  use MultiTenancexWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :admin_layout do
    plug(:put_layout, {MultiTenancexWeb.Admin.LayoutView, :admin})
  end

  pipeline :browser_session do
    # plug Guardian.Plug.VerifySession
    # plug Guardian.Plug.LoadResource
  end

  pipeline :authenticated_admin do
    # plug Guardian.Plug.EnsureAuthenticated, handler: MultiTenancexWeb.Admin.SessionController
    # plug Guardian.Plug.EnsureResource, handler: MultiTenancexWeb.Admin.SessionController

    # Custom plugs
    plug(MultiTenancexWeb.Plug.CurrentAdmin)
    plug(MultiTenancexWeb.Plug.CurrentTenant)
  end

  pipeline :unauthenticated_admin do
    # plug Guardian.Plug.EnsureNotAuthenticated, handler: MultiTenancexWeb.Admin.SessionController
  end

  scope "/", MultiTenancexWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Admin scope
  scope "/admin", MultiTenancexWeb.Admin, as: :admin do
    pipe_through([:browser, :browser_session])

    # Admin unauthenticated scope
    scope "/" do
      pipe_through([:unauthenticated_admin])

      resources("/session", SessionController, only: [:new, :create])
    end

    # Admin authenticated scope
    scope "/" do
      pipe_through([:admin_layout, :authenticated_admin])

      # Log out resource
      get("/logout", SessionController, :delete)

      # Switch tenant resource
      post("/switch_tenant", DashboardController, :switch_tenant)

      resources("/", DashboardController, only: [:index])
      resources("/administrators", AdministratorController)
      resources("/companies", CompanyController)
      resources("/products", ProductController)
    end
  end
end
