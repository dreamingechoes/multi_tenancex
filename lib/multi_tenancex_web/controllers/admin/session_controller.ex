defmodule MultiTenancexWeb.Admin.SessionController do
  alias MultiTenancexWeb.AdminSession

  use MultiTenancexWeb, :controller

  plug :put_layout, {MultiTenancexWeb.Admin.LayoutView, "admin_auth.html"}

  @doc """
  Displays the login form for administrators.
  """
  def new(conn, _params), do: render(conn, "new.html")

  @doc """
  Creates a new session for an administrator.
  """
  def create(conn, %{"session" => session_params}) do
    with company_name <- generate_name(session_params["company"]),
         session_params <- Map.put(session_params, "company", company_name)
    do
      case AdminSession.authenticate(session_params) do
        {:ok, admin} ->
          claims =
            Guardian.Claims.app_claims
            |> Map.put(:current_admin_tenant, company_name)

          conn
          |> Guardian.Plug.sign_in(admin, nil, claims)
          |> put_flash(:info, gettext("You have successfuly logged in."))
          |> redirect(to: admin_dashboard_path(conn, :index))
        :error ->
          conn
          |> put_flash(:error, gettext("Wrong username or password or company name"))
          |> put_status(:bad_request)
          |> render("new.html")
      end
    end
  end

  @doc """
  Deletes a session for an administrator.
  """
  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, gettext("You have successfuly logged out."))
    |> redirect(to: admin_session_path(conn, :new))
  end

  @doc """
  Redirects anonymous users to the login page.
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, gettext("You must be logged in as an administrator to access this page."))
    |> redirect(to: admin_session_path(conn, :new))
  end

  @doc """
  Redirects already logged users to the index page.
  """
  def already_authenticated(conn, _params) do
    conn
    |> put_flash(:info, gettext("You are already authenticated."))
    |> redirect(to: admin_dashboard_path(conn, :index))
  end

  @doc """
  Redirects to the login page if the Administrator can not be loaded.
  """
  def no_resource(conn, _params) do
    conn
    |> put_flash(:error, gettext("You are not signed in."))
    |> redirect(to: admin_session_path(conn, :new))
  end

  defp generate_name(name) do
    name
    |> String.split("_")
    |> List.delete_at(0)
    |> Enum.join("_")
  end
end
