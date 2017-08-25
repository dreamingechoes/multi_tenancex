defmodule MultiTenancex.AccountsTest do
  use MultiTenancex.DataCase

  alias MultiTenancex.Accounts

  describe "administrators" do
    alias MultiTenancex.Accounts.Administrator

    @valid_attrs %{email: "some email", firstname: "some firstname", lastname: "some lastname"}
    @update_attrs %{email: "some updated email", firstname: "some updated firstname", lastname: "some updated lastname"}
    @invalid_attrs %{email: nil, firstname: nil, lastname: nil}

    def administrator_fixture(attrs \\ %{}) do
      {:ok, administrator} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_administrator()

      administrator
    end

    test "list_administrators/0 returns all administrators" do
      administrator = administrator_fixture()
      assert Accounts.list_administrators() == [administrator]
    end

    test "get_administrator!/1 returns the administrator with given id" do
      administrator = administrator_fixture()
      assert Accounts.get_administrator!(administrator.id) == administrator
    end

    test "create_administrator/1 with valid data creates a administrator" do
      assert {:ok, %Administrator{} = administrator} = Accounts.create_administrator(@valid_attrs)
      assert administrator.email == "some email"
      assert administrator.firstname == "some firstname"
      assert administrator.lastname == "some lastname"
    end

    test "create_administrator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_administrator(@invalid_attrs)
    end

    test "update_administrator/2 with valid data updates the administrator" do
      administrator = administrator_fixture()
      assert {:ok, administrator} = Accounts.update_administrator(administrator, @update_attrs)
      assert %Administrator{} = administrator
      assert administrator.email == "some updated email"
      assert administrator.firstname == "some updated firstname"
      assert administrator.lastname == "some updated lastname"
    end

    test "update_administrator/2 with invalid data returns error changeset" do
      administrator = administrator_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_administrator(administrator, @invalid_attrs)
      assert administrator == Accounts.get_administrator!(administrator.id)
    end

    test "delete_administrator/1 deletes the administrator" do
      administrator = administrator_fixture()
      assert {:ok, %Administrator{}} = Accounts.delete_administrator(administrator)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_administrator!(administrator.id) end
    end

    test "change_administrator/1 returns a administrator changeset" do
      administrator = administrator_fixture()
      assert %Ecto.Changeset{} = Accounts.change_administrator(administrator)
    end
  end
end
