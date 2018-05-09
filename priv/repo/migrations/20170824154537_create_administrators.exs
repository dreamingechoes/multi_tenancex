defmodule MultiTenancex.Repo.Migrations.CreateAdministrators do
  use Ecto.Migration

  def change do
    create table(:administrators) do
      add(:firstname, :string)
      add(:lastname, :string)
      add(:email, :string)
      add(:encrypted_password, :string, null: false)

      timestamps()
    end

    create(unique_index(:administrators, [:email]))
  end
end
