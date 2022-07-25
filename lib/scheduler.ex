#defmodule Schedule do
#  defstruct id: nil, task: "", scheduled: ""
#end



#defmodule MyApp.Scheduler do
#  use GenServer
#
#  def start_link(_args) do
#	GenServer.start_link(_MODULE_, %{})
#  end
#  def init(state) do
#	schedule_work()
#  end
#
#  def handle_info(:kill, state) do
#	MyApp.Module.do()
#	schedule_work()
#	{:no_reply, state}
#  end
#
#  defp schedule_work() do
#	Process.send_after(self(), :work, 2 * 60 * 60 * 1000)
#  end
#
#end
#
