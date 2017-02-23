defmodule Bugsnex.Worker do
  @moduledoc false

  use GenServer

  # client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def notify(exception) do
    GenServer.cast(__MODULE__, {:notify, exception})
  end

  # server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:notify, exception}, state) do
    {:ok, state}
  end
end
