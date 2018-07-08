defmodule Mix.Tasks.MultiTenancex.Ecto.RollbackTenants do
  use Mix.Task

  import Mix.Ecto

  alias MultiTenancex.TenantActions

  @shortdoc "Rolls back the repository migrations in tenants"

  @doc false
  def run(_args) do
    Code.compiler_options(ignore_module_conflict: true)
    {:ok, _, _} = ensure_started(MultiTenancex.Repo, [])
    Ecto.Adapters.SQL.Sandbox.checkin(MultiTenancex.Repo)

    tenants = TenantActions.list_tenants(MultiTenancex.Repo)
    Enum.each(tenants, &migrate_tenant/1)
    Mix.shell().info("Rollback completed")
  end

  defp migrate_tenant(tenant) do
    TenantActions.migrate_tenant(MultiTenancex.Repo, tenant, :down)
    Mix.shell().info("#{tenant} rolled back")
  end
end
