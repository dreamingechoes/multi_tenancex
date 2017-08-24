use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :multi_tenancex, MultiTenancexWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :multi_tenancex, MultiTenancex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "multi_tenancex_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
