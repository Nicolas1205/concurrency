# TODO: so we have to change to configuration of a certain schedule
# which is concurrently running
# so we get to kill and restart that process with the new config

defmodule Scheduler do

  def update_schedule(updated_schedule, pid) do
    send pid, :update
    new_pid = spawn_link Concurrency, :match_schedule, [updated_schedule]
    Map.get_and_update(updated_schedule, :pid, new_pid)
    :ok
  end

end

defmodule Scheduler.DB do
  def get_schedules do
    {_, raw} = File.read("./lib/config.json");
    {:ok, schedules} = Jason.decode(raw);
	Parser.get_schedule_from_map(schedules)
  end
end

defmodule Concurrency do
  def main do
    schedules = Scheduler.DB.get_schedules

    # TODO: Implement Agent for stateful pids var

	pids = Enum.map(schedules, fn schedule -> spawn_link(Concurrency, :match_schedule, [schedule]) end)

	inspect(pids)

    #case ok? do
    #  :ok ->  pids = Enum.map(schedules, fn schedule ->
    #    spawn_link(Concurrency, :match_schedule, [schedule]) end)
    #  _ ->
    #    IO.puts(:stderr, "An error deserializing")
    #    :error
    #end
  end

	# schedule: Schedule
  def match_schedule(schedule) do

    IO.puts("Trying Again")
    {ok?, ndt_scheduled} = NaiveDateTime.from_iso8601(schedule.scheduled)

    #case ok? do
    #  :error -> raise ArgumentError, "Error parsing schedule"
	#   _ -> _
    #end

    new_ndt = NaiveDateTime.local_now
    trunc_ndt = NaiveDateTime.add(new_ndt, -new_ndt.second)

    case ndt_scheduled do
      ^trunc_ndt ->
        IO.puts("Hello world from #{self()}")
        System.cmd("notify-send", [schedule.task])
      _ ->
        :timer.sleep(1000)
        match_schedule(schedule)
    end

    :ok
  end
end
