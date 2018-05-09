# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :multi_tenancex,
  ecto_repos: [MultiTenancex.Repo]

# Configures the endpoint
config :multi_tenancex, MultiTenancexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "lg4XZozBjOZtmXbtmS+XZ2VjyK/4364nju982apsGULjxFe4sKYfy8yxby8AXIFr",
  render_errors: [view: MultiTenancexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MultiTenancex.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian configuration
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "MultiTenancex",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  serializer: MultiTenancexWeb.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
