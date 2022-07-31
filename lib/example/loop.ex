defmodule Loop do
  use GenServer
  def start_link(args) do
    GenServer.start_link(__MODULE__, args[:state], name: args[:name])
  end

  def init(state) do
    run_process()
    {:ok, state}
  end

  # Client API
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end


  def handle_info(:run, state) do
    IO.inspect(state)
    run_process()
    num =  [1,2,3]
        |> Enum.random
        |> Kernel.+(0)
    {:noreply, [num | state]}
  end

  def run_process() do
    Process.send_after(self(), :run, 2000)
  end
 end
