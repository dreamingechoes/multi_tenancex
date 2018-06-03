defmodule MultiTenancexWeb.Admin.LayoutView do
  alias MultiTenancex.TenantActions

  use MultiTenancexWeb, :view

  def select_tenant_options do
    TenantActions.list_tenants(MultiTenancex.Repo)
  end
end
