defmodule MultiTenancexWeb.GuardianSerializer do
  alias MultiTenancex.Accounts

  @behaviour Guardian.Serializer

  def for_token(%{administrator: administrator, company: company}) do
    {:ok, "Data:#{administrator.id}-#{company}"}
  end
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("Data:" <> data) do
    [administrator_id, _company] = String.split(data, "-")
    administrator = Accounts.get_administrator!(administrator_id)
    
    {:ok, administrator}
  end
  def from_token(_), do: {:error, "Unknown resource type"}
end
