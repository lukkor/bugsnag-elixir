use Mix.Config

config :bugsnag_elixir,
  api_endpoint: "https://notify.bugsnag.com",
  api_token: System.get_env("BUGSNAG_API_TOKEN"),
  release_stage: 'prod',
  auto_notify: true,
  use_ssl: true
