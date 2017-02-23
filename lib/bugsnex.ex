defmodule Bugsnex do
  @moduledoc ~S"""
  Bugsnag error reporting for Elixir
  """

  use Application

  def start(_type, _args) do
    Bugsnex.Supervisor.start_link
  end

  defdelegate notify(exception), to: Bugsnex.Worker
end
