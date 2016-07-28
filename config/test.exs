use Mix.Config

config :bugsnex,
  api_endpoint: "https://api.bugsnag.com",
  api_token: System.get_env("BUGSNAG_API_TOKEN")
