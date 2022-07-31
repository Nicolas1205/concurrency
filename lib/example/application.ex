defmodule App do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, :ok, args)
  end

  def init(:ok) do
    children = [
      {Loop , [name: Loop, state: []]}
    ]

    Supervisor.init(children, strategy: :one_for_one)

  end

  def get_updates() do
    IO.puts("Here State")
    state = Loop.get_state()
    state
  end
end
