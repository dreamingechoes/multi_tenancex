defmodule MultiTenancexWeb.HelperController do
  @moduledoc """
  Provides helper functions for controllers.
  """

  @doc """
  Get the current administrator.

  Returns a `%MultiTenancex.Administrator{}` struct with the current administrator or `nil` if none.
  """
  @spec current_admin(conn :: Plug.Conn.t) :: MultiTenancex.Administrator.t | nil
  def current_admin(conn), do: conn.assigns[:current_admin]

  @doc """
  Get the current tenant.

  Returns a `tenant_id` with the current tenant or `nil` if none.
  """
  @spec current_tenant(conn :: Plug.Conn.t) :: String.t | nil
  def current_tenant(conn), do: conn.assigns[:current_tenant]

  @doc """
  Get the current admin tenant.

  Returns a `tenant_id` with the current admin tenant or `nil` if none.
  """
  @spec current_admin_tenant(conn :: Plug.Conn.t) :: String.t | nil
  def current_admin_tenant(conn), do: conn.assigns[:current_admin_tenant]
end
