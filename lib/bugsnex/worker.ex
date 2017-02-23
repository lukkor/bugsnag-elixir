defmodule Bugsnex.Worker do
  @moduledoc false

  use GenServer

  # client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @spec notify(Exception.t) :: :ok
  def notify(exception) do
    GenServer.cast(__MODULE__, {:notify, exception})
  end

  # server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  @spec handle_cast({:notify, Exception.t}, term) :: term
  def handle_cast({:notify, exception}, state) do
    exception
    |> Bugsnex.Parser.parse
    |> Bugsnex.Notifier.notify

    {:ok, state}
  end
end
