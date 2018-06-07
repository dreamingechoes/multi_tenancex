defmodule Mix.Tasks.MultiTenancex.Ecto.MigrateTenants do
  use Mix.Task
  import Mix.Ecto

  alias MultiTenancex.TenantActions

  @shortdoc "Runs the repository migrations in tenants"

  @doc false
  def run(_args) do
    Code.compiler_options(ignore_module_conflict: true)
    {:ok, _, _} = ensure_started(MultiTenancex.Repo, [])
    Ecto.Adapters.SQL.Sandbox.checkin(MultiTenancex.Repo)

    tenants = TenantActions.list_tenants(MultiTenancex.Repo)
    Enum.each(tenants, &migrate_tenant/1)
    Mix.shell().info("Migrations completed")
  end

  defp migrate_tenant(tenant) do
    TenantActions.migrate_tenant(MultiTenancex.Repo, tenant, :up)
    Mix.shell().info("#{tenant} migrated")
  end
end
