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
    end

    # Admin scope
    scope "/admin", Admin, as: :admin do
      pipe_through([:browser, :browser_auth])

      # Admin unauthenticated scope
      resources("/session", SessionController, only: [:new, :create])

      # Admin authenticated scope
      scope "/" do
        pipe_through([:admin_layout, :browser_auth, :browser_ensure_auth])

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
end
