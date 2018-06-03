defmodule MultiTenancex.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:name, :string)
      add(:description, :string)
      add(:image, :string)
      add(:slug, :string)

      timestamps()
    end

    create(unique_index(:companies, [:name]))
  end
end
