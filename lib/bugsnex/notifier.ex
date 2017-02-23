defmodule Bugsnex.Notifier do
  @moduledoc false

  @spec notify(Bugsnex.Exception.t) :: term
  def notify(payload) do
    IO.puts(Poison.encode!(payload))
  end
end
