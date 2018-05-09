defmodule MultiTenancexWeb.Admin.AdministratorController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Accounts
  alias MultiTenancex.Accounts.Administrator

  def index(conn, _params) do
    administrators = Accounts.list_administrators()
    render(conn, "index.html", administrators: administrators)
  end

  def new(conn, _params) do
    changeset = Accounts.change_administrator(%Administrator{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"administrator" => administrator_params}) do
    case Accounts.create_administrator(administrator_params) do
      {:ok, administrator} ->
        conn
        |> put_flash(:info, "Administrator created successfully.")
        |> redirect(to: admin_administrator_path(conn, :show, administrator))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    administrator = Accounts.get_administrator!(id)
    render(conn, "show.html", administrator: administrator)
  end

  def edit(conn, %{"id" => id}) do
    administrator = Accounts.get_administrator!(id)
    changeset = Accounts.change_administrator(administrator)

    render(
      conn,
      "edit.html",
      administrator: administrator,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "administrator" => administrator_params}) do
    administrator = Accounts.get_administrator!(id)

    case Accounts.update_administrator(administrator, administrator_params) do
      {:ok, administrator} ->
        conn
        |> put_flash(:info, "Administrator updated successfully.")
        |> redirect(to: admin_administrator_path(conn, :show, administrator))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          administrator: administrator,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    administrator = Accounts.get_administrator!(id)
    {:ok, _administrator} = Accounts.delete_administrator(administrator)

    conn
    |> put_flash(:info, "Administrator deleted successfully.")
    |> redirect(to: admin_administrator_path(conn, :index))
  end
end
