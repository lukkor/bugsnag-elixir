defmodule Bugsnex.Worker do
  @moduledoc false

  use GenServer

  # client API

  @spec start_link :: GenServer.on_start
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec notify(Exception.t | Bugsnex.Event.t | Bugsnex.Exception.t) :: :ok
  def notify(exception = %Bugsnex.Exception{}), do: exception |> Bugsnex.Event.new |> notify
  def notify(event = %Bugsnex.Event{}) do
    GenServer.cast(__MODULE__, {:notify, event})
  end
  def notify(exception = %{}), do: exception |> Bugsnex.Event.new |> notify

  # server callbacks

  def init([]) do
    {:ok, %{}}
  end

  @callback handle_cast({:notify, Bugsnex.Event.t}, term) :: {:noreply, term}
  def handle_cast({:notify, event}, state) do
    event |> Bugsnex.Notifier.notify
    {:noreply, state}
  end
end
