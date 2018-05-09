defmodule MultiTenancexWeb.AdminSession do
  @moduledoc """
  Manage the admin session.
  """
  alias MultiTenancex.Accounts.Administrator
  alias MultiTenancex.Repo

  @doc """
  Authenticate an Administrator using its email and password.
  """
  @spec authenticate(map) :: {:ok, Administrator.t()} | :error
  def authenticate(%{"email" => email, "password" => password}) do
    with admin <- Repo.get_by(Administrator, email: email) do
      if check_password(admin, password), do: {:ok, admin}, else: :error
    end
  end

  defp check_password(nil, _), do: Comeonin.Bcrypt.dummy_checkpw()

  defp check_password(admin, pwd),
    do: Comeonin.Bcrypt.checkpw(pwd, admin.encrypted_password)
end
