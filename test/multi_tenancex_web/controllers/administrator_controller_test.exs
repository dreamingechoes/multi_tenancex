defmodule MultiTenancexWeb.AdministratorControllerTest do
  use MultiTenancexWeb.ConnCase

  alias MultiTenancex.Accounts

  @create_attrs %{email: "some email", firstname: "some firstname", lastname: "some lastname"}
  @update_attrs %{email: "some updated email", firstname: "some updated firstname", lastname: "some updated lastname"}
  @invalid_attrs %{email: nil, firstname: nil, lastname: nil}

  def fixture(:administrator) do
    {:ok, administrator} = Accounts.create_administrator(@create_attrs)
    administrator
  end

  describe "index" do
    test "lists all administrators", %{conn: conn} do
      conn = get conn, admin_administrator_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Administrators"
    end
  end

  describe "new administrator" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_administrator_path(conn, :new)
      assert html_response(conn, 200) =~ "New Administrator"
    end
  end

  describe "create administrator" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, admin_administrator_path(conn, :create), administrator: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_administrator_path(conn, :show, id)

      conn = get conn, admin_administrator_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Administrator"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_administrator_path(conn, :create), administrator: @invalid_attrs
      assert html_response(conn, 200) =~ "New Administrator"
    end
  end

  describe "edit administrator" do
    setup [:create_administrator]

    test "renders form for editing chosen administrator", %{conn: conn, administrator: administrator} do
      conn = get conn, admin_administrator_path(conn, :edit, administrator)
      assert html_response(conn, 200) =~ "Edit Administrator"
    end
  end

  describe "update administrator" do
    setup [:create_administrator]

    test "redirects when data is valid", %{conn: conn, administrator: administrator} do
      conn = put conn, admin_administrator_path(conn, :update, administrator), administrator: @update_attrs
      assert redirected_to(conn) == admin_administrator_path(conn, :show, administrator)

      conn = get conn, admin_administrator_path(conn, :show, administrator)
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, administrator: administrator} do
      conn = put conn, admin_administrator_path(conn, :update, administrator), administrator: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Administrator"
    end
  end

  describe "delete administrator" do
    setup [:create_administrator]

    test "deletes chosen administrator", %{conn: conn, administrator: administrator} do
      conn = delete conn, admin_administrator_path(conn, :delete, administrator)
      assert redirected_to(conn) == admin_administrator_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_administrator_path(conn, :show, administrator)
      end
    end
  end

  defp create_administrator(_) do
    administrator = fixture(:administrator)
    {:ok, administrator: administrator}
  end
end
