defmodule MultiTenancexWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import MultiTenancexWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint MultiTenancexWeb.Endpoint

      def log_in(administrator),
        do: log_in(Phoenix.ConnTest.build_conn(), administrator)

      def log_in(conn, administrator) do
        MultiTenancex.Guardian.Plug.sign_in(
          conn,
          administrator,
          %{
            current_tenant: "tenant_some_name"
          }
        )
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MultiTenancex.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MultiTenancex.Repo, {:shared, self()})
    end

    {:ok, administrator} =
      MultiTenancex.Accounts.create_administrator(%{
        email: "example@example.com",
        firstname: "some first name",
        lastname: "some last name",
        password: "123456"
      })

    {:ok, conn: Phoenix.ConnTest.build_conn(), administrator: administrator}
  end
end
