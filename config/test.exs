import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :payment_api, PaymentApiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: "3iqdCRRSPw88dldHSdlc1sCdsWf2Kems72arx1BEzD4C+07jADLPsQynx+ltXl8L",
  server: false

# In test we don't send emails
config :payment_api, PaymentApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :payment_api, PaymentApi.MercadoPago.QrCode, adapter: Tesla.Mock
