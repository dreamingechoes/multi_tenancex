defmodule MultiTenancex.Accounts.Administrator do
  alias MultiTenancex.Accounts.Administrator
  import Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  schema "administrators" do
    field :email,               :string
    field :firstname,           :string
    field :lastname,            :string
    field :encrypted_password,  :string
    field :password,            :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Administrator{} = administrator, attrs) do
    administrator
    |> cast(attrs, [:firstname, :lastname, :email, :password])
    |> validate_required([:firstname, :lastname, :email, :password])
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> generate_encrypted_password()
  end

  defp generate_encrypted_password(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
    end
  end
  defp generate_encrypted_password(changeset), do: changeset
end
