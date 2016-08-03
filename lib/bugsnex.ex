defmodule Bugsnex do
  @moduledoc """
  Base module to access Bugsnag Data access API.

  ## Dependencies

    - HTTPoison: used to request Bugsnag API
    - Poison: used to decode JSON response
  """

  use Application
  use HTTPoison.Base

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Bugsnex.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bugsnex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @expected_fields ~w(
    id name url created_at updated_at
    account_creator billing_contact
  )

  def process_url(endpoint) do
    Application.fetch_env!(:bugsnex, :api_endpoint) <> endpoint
  end

  def process_request_headers(headers) do
    Dict.put(headers, :"Authorization", "token " <> Application.fetch_env!(:bugsnex, :api_token))
  end

  def process_response_body(body) do
    body
    |> Poison.decode!([{:label, :atom}])
    |> Map.take(@expected_fields)
  end
end
