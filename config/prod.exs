use Mix.Config

config :bugsnex,
  api_endpoint: "https://notify.bugsnag.com",
  api_token: System.get_env("BUGSNAG_API_TOKEN"),
  release_stage: 'prod',
  auto_notify: true,
  use_ssl: true
