defmodule Bugsnex do
  @moduledoc ~S"""
  Bugsnag error reporting for Elixir
  """

  use Application

  def start(_type, _args) do
    Bugsnex.Supervisor.start_link
  end

  @spec notify(Exception.t | Bugsnex.Event.t | Bugsnex.Exception.t) :: :ok
  defdelegate notify(exception), to: Bugsnex.Worker
end
