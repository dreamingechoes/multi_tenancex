defmodule MultiTenancexWeb.Router do
  use MultiTenancexWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :browser_auth do
    plug(MultiTenancexWeb.Guardian.AuthPipeline)
    plug(MultiTenancexWeb.Plug.CurrentAdmin)
  end

  pipeline :browser_ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(MultiTenancexWeb.Plug.CurrentAdmin)
  end

  pipeline :admin_layout do
    plug(:put_layout, {MultiTenancexWeb.Admin.LayoutView, :admin})
  end

  scope "/", MultiTenancexWeb do
    # Application unauthenticated scope
    scope "/" do
      pipe_through([:browser, :browser_auth])

      get("/", PageController, :index)

      resources("/session", SessionController, only: [:new, :create])

      # Log out resource
      get("/logout", SessionController, :delete)
    end

    # Admin scope
    scope "/admin", Admin, as: :admin do
      pipe_through([:browser, :browser_auth, :browser_ensure_auth, :admin_layout])

      # Switch tenant resource
      post("/switch_tenant", DashboardController, :switch_tenant)

      resources("/", DashboardController, only: [:index])
      resources("/administrators", AdministratorController)
      resources("/companies", CompanyController)
      resources("/products", ProductController)
    end
  end
end
