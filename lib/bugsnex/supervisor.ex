defmodule Bugsnex.Supervisor do
  @moduledoc false

  use Supervisor

  @spec start_link :: Supervisor.on_start
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [worker(Bugsnex.Worker, [])]
    supervise(children, strategy: :one_for_one)
  end
end
