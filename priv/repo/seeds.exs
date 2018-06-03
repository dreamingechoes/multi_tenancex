alias MultiTenancex.Accounts
alias MultiTenancex.Companies

# Create a default administrator
Accounts.create_administrator(%{
  email: "example@example.com",
  password: "123456",
  firstname: "Example",
  lastname: "Example"
})

# Create four companies with some products
Enum.each(0..3, fn _ ->
  {:ok, company} =
    Companies.create_company(%{
      name: Faker.Company.name(),
      description: Faker.Lorem.paragraph(%Range{first: 1, last: 2}),
      image: Faker.Avatar.image_url(800, 200)
    })

  Enum.each(0..6, fn n ->
    Companies.create_product(
      %{
        name: Faker.Lorem.word(),
        description: Faker.Lorem.paragraph(%Range{first: 1, last: 2}),
        image: Faker.Avatar.image_url(200, 120),
        company_id: company.id,
        price: 29.95,
        units: 10 * (n + 1)
      },
      "tenant_" <> company.slug
    )
  end)
end)
