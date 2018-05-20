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
config :multi_tenancex, MultiTenancex.Guardian,
  issuer: "multi_tenancex",
  secret_key: "eP/Fjhc5Ns4WsmYqBqwvC51oA0i/aXYeobBLn8V7Rrtyddfct48rimYbVQj28MAX"

config :multi_tenancex, MultiTenancexWeb.AuthPipeline,
  module: MultiTenancexWeb.Guardian,
  error_handler: MultiTenancexWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
