defmodule BugsnagElixir do
  @moduledoc ~S"""
  Bugsnag error reporting for Elixir
  """

  use Application

  def start(_type, _args) do
    BugsnagElixir.Supervisor.start_link
  end

  @spec notify(Exception.t | BugsnagElixir.Event.t | BugsnagElixir.Exception.t) :: :ok
  defdelegate notify(exception), to: BugsnagElixir.Worker
end
