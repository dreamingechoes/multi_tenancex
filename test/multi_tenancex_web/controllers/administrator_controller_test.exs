defmodule MultiTenancexWeb.AdministratorControllerTest do
  use MultiTenancexWeb.ConnCase

  alias MultiTenancex.Accounts

  @create_attrs %{
    email: "some admin email",
    firstname: "some admin firstname",
    lastname: "some admin lastname",
    password: "123456"
  }
  @update_attrs %{
    email: "some updated admin email",
    firstname: "some updated admin firstname",
    lastname: "some updated admin lastname",
    password: "other_password"
  }
  @invalid_attrs %{email: nil, firstname: nil, lastname: nil}

  def fixture(:administrator) do
    {:ok, new_administrator} = Accounts.create_administrator(@create_attrs)
    new_administrator
  end

  describe "index" do
    test "lists all administrators", %{conn: conn, administrator: administrator} do
      conn = get(log_in(administrator), admin_administrator_path(conn, :index))
      assert html_response(conn, 200) =~ "List of administrators"
    end
  end

  describe "new administrator" do
    test "renders form", %{conn: conn, administrator: administrator} do
      conn = get(log_in(administrator), admin_administrator_path(conn, :new))
      assert html_response(conn, 200) =~ "New administrator"
    end
  end

  describe "create administrator" do
    test "redirects to show when data is valid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        post(
          log_in(administrator),
          admin_administrator_path(conn, :create),
          administrator: @create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_administrator_path(conn, :show, id)

      conn =
        get(log_in(administrator), admin_administrator_path(conn, :show, id))

      assert html_response(conn, 200) =~ "Show administrator"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        post(
          log_in(administrator),
          admin_administrator_path(conn, :create),
          administrator: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New administrator"
    end
  end

  describe "edit administrator" do
    test "renders form for editing chosen administrator", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        get(
          log_in(administrator),
          admin_administrator_path(conn, :edit, administrator)
        )

      assert html_response(conn, 200) =~ "Edit administrator"
    end
  end

  describe "update administrator" do
    test "redirects when data is valid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        put(
          log_in(administrator),
          admin_administrator_path(conn, :update, administrator),
          administrator: @update_attrs
        )

      assert redirected_to(conn) ==
               admin_administrator_path(conn, :show, administrator)

      conn =
        get(
          log_in(administrator),
          admin_administrator_path(conn, :show, administrator)
        )

      assert html_response(conn, 200) =~ "some updated admin email"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        put(
          log_in(administrator),
          admin_administrator_path(conn, :update, administrator),
          administrator: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit administrator"
    end
  end

  describe "delete administrator" do
    test "deletes chosen administrator", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        delete(
          log_in(administrator),
          admin_administrator_path(conn, :delete, administrator)
        )

      assert redirected_to(conn) == admin_administrator_path(conn, :index)
    end
  end
end
