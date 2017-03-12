defmodule BugsnagElixir.Worker do
  @moduledoc false

  use GenServer

  # client API

  @spec start_link :: GenServer.on_start
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec notify(Exception.t | BugsnagElixir.Event.t | BugsnagElixir.Exception.t) :: :ok
  def notify(exception = %BugsnagElixir.Exception{}), do: exception |> BugsnagElixir.Event.new |> notify
  def notify(event = %BugsnagElixir.Event{}) do
    GenServer.cast(__MODULE__, {:notify, event})
  end
  def notify(exception = %{}), do: exception |> BugsnagElixir.Event.new |> notify

  # server callbacks

  def init([]) do
    {:ok, %{}}
  end

  @callback handle_cast({:notify, BugsnagElixir.Event.t}, term) :: {:noreply, term}
  def handle_cast({:notify, event}, state) do
    event |> BugsnagElixir.Notifier.notify
    {:noreply, state}
  end
end
