ExUnit.configure(exclude: [skip: true])
ExUnit.start()

# Create a tenant for tests. For performance reasons, the tenant is created and
# migrated only once before running all the tests.
{:ok, _company} =
  MultiTenancex.Companies.create_company(%{
    description: "some description",
    image: "some image",
    name: "some name"
  })

Ecto.Adapters.SQL.Sandbox.mode(MultiTenancex.Repo, :manual)
Code.compiler_options(ignore_module_conflict: true)
