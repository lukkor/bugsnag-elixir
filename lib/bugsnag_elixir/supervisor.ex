defmodule BugsnagElixir.Supervisor do
  @moduledoc false

  use Supervisor

  @spec start_link :: Supervisor.on_start
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  @spec init(list) :: any
  def init([]) do
    children = [worker(BugsnagElixir.Worker, [])]
    supervise(children, strategy: :one_for_one)
  end
end
