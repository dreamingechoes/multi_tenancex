defmodule MultiTenancexWeb.SessionController do
  alias MultiTenancex.Guardian
  alias MultiTenancex.Guardian.Plug

  use MultiTenancexWeb, :controller

  plug(:put_layout, {MultiTenancexWeb.Admin.LayoutView, "admin_auth.html"})

  def new(conn, _), do: render(conn, "new.html")

  def create(conn, %{
        "session" => %{
          "tenant" => tenant,
          "email" => email,
          "password" => password
        }
      }) do
    case Guardian.authenticate_administrator(email, password) do
      {:ok, administrator} ->
        conn
        |> Plug.sign_in(administrator, %{current_tenant: tenant})
        |> put_flash(:success, gettext("Welcome to Multi Tenancex!"))
        |> redirect(to: page_path(conn, :index))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> Plug.sign_out()
    |> redirect(to: page_path(conn, :index))
  end
end
