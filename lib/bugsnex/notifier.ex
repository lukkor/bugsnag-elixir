defmodule Bugsnex.Notifier do
  @moduledoc false

  @spec notify(Bugsnex.Exception.t) :: term
  def notify(_payload) do
    :ok
  end
end
