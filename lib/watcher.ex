defmodule Watcher do
  use GenServer
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
	IO.puts(path)
	Enum.map events, fn event -> IO.puts(event) end
    {:noreply, state}
  end

  #def handle_info({:file_event, _watcher_pid , {path , events}}) do
  #  {:noreply, :ok}
  #end

  def handle_info({file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
	IO.puts("Some Stoped")
    {:noreply, state}
  end
end
