import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :food_truck, FoodTruckWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1JyNPtsCb8NuARBLql8X+vV1EOkCFHVHuSXruwwkM+AoYzHnTiExmiNUK+MEnh0M",
  server: false

# In test we don't send emails.
config :food_truck, FoodTruck.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Use Tesla Mock adapter to avoid making real API calls in tests
config :tesla, adapter: Tesla.Mock
