defmodule MultiTenancexWeb.CompanyControllerTest do
  use MultiTenancexWeb.ConnCase

  alias MultiTenancex.Companies

  @create_attrs %{
    description: "some description",
    image: "some image",
    name: "some fake name"
  }
  @update_attrs %{
    description: "some updated description",
    image: "some updated image",
    name: "some updated fake name"
  }
  @invalid_attrs %{description: nil, image: nil, name: nil, slug: nil}

  def fixture(:company) do
    {:ok, company} = Companies.create_company(@create_attrs)
    company
  end

  describe "index" do
    test "lists all companies", %{conn: conn, administrator: administrator} do
      conn = get(log_in(administrator), admin_company_path(conn, :index))
      assert html_response(conn, 200) =~ "List of companies"
    end
  end

  describe "new company" do
    test "renders form", %{conn: conn, administrator: administrator} do
      conn = get(log_in(administrator), admin_company_path(conn, :new))
      assert html_response(conn, 200) =~ "New company"
    end
  end

  describe "create company" do
    test "redirects to show when data is valid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        post(
          log_in(administrator),
          admin_company_path(conn, :create),
          company: @create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_company_path(conn, :show, id)

      conn = get(log_in(administrator), admin_company_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show company"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        post(
          log_in(administrator),
          admin_company_path(conn, :create),
          company: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New company"
    end
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{
      conn: conn,
      administrator: administrator,
      company: company
    } do
      conn =
        get(log_in(administrator), admin_company_path(conn, :edit, company))

      assert html_response(conn, 200) =~ "Edit company"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{
      conn: conn,
      administrator: administrator,
      company: company
    } do
      conn =
        put(
          log_in(administrator),
          admin_company_path(conn, :update, company),
          company: @update_attrs
        )

      assert redirected_to(conn) == admin_company_path(conn, :show, company)

      conn =
        get(log_in(administrator), admin_company_path(conn, :show, company))

      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      administrator: administrator,
      company: company
    } do
      conn =
        put(
          log_in(administrator),
          admin_company_path(conn, :update, company),
          company: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit company"
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{
      conn: conn,
      administrator: administrator,
      company: company
    } do
      conn =
        delete(
          log_in(administrator),
          admin_company_path(conn, :delete, company)
        )

      assert redirected_to(conn) == admin_company_path(conn, :index)
    end
  end

  defp create_company(_), do: {:ok, company: fixture(:company)}
end
