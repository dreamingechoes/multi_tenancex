defmodule MultiTenancex.TenantActions do
  @moduledoc ~S"""
  MultiTenancex TenantActions module.

  Includes basic actions for migrations.
  """
  alias Ecto.Adapters.SQL

  import Ecto.Query, only: [from: 2]

  require Logger

  @migrations_folder "tenant_migrations"
  @schema_prefix "tenant_"

  @doc ~S"""
  Apply migrations to a tenant. A direction can be given (:up or :down).
  Default value is :up. A strategy can be given as an option, and defaults to `:all`.

  ## Options

    - `:all`: runs all available if `true`.
    - `:step`: runs the specific number of migrations.
    - `:to`: runs all until the supplied version is reached.
    - `:log`: the level to use for logging. Defaults to `:info`.

  """
  def migrate_tenant(repo, tenant, direction \\ :up, opts \\ [all: true]) do
    with result <- migrate_and_return_status(repo, tenant, direction, opts),
         {:error, tenant_name, error_msg} <- result do
      Logger.error(
        "Error while migrating tenant '#{tenant_name}'. Error was:\n #{
          error_msg
        }"
      )

      result
    end
  end

  def new_tenant(repo, tenant) do
    create_schema(repo, tenant)
    migrate_tenant(repo, tenant)
  end

  def create_schema(repo, tenant) do
    SQL.query(repo, "CREATE SCHEMA \"#{build_prefix(tenant)}\"", [])
  end

  def drop_schema(repo, tenant) do
    SQL.query(repo, "DROP SCHEMA \"#{build_prefix(tenant)}\" CASCADE", [])
  end

  def list_tenants(repo) do
    query =
      from(
        schemata in "schemata",
        select: schemata.schema_name,
        where: like(schemata.schema_name, ^"#{@schema_prefix}%")
      )

    repo.all(query, prefix: "information_schema")
  end

  def build_prefix(@schema_prefix <> tenant), do: @schema_prefix <> tenant

  def build_prefix(tenant) do
    tenant_id =
      tenant
      |> String.downcase()
      |> String.replace(" ", "_")

    @schema_prefix <> tenant_id
  end

  def tenant_migrations_path(repo) do
    priv_path_for(repo, @migrations_folder)
  end

  # Helpers
  defp migrate_and_return_status(repo, tenant, direction, opts) do
    prefix = build_prefix(tenant)

    {status, versions} =
      handle_database_exceptions(fn ->
        opts_with_prefix = Keyword.put(opts, :prefix, prefix)

        Ecto.Migrator.run(
          repo,
          tenant_migrations_path(repo),
          direction,
          opts_with_prefix
        )
      end)

    {status, prefix, versions}
  end

  defp handle_database_exceptions(fun) do
    {:ok, fun.()}
  rescue
    e in Postgrex.Error -> {:error, Postgrex.Error.message(e)}
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp priv_path_for(repo, filename) do
    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join([priv_dir(:multi_tenancex), repo_underscore, filename])
  end
end
