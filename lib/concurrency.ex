defmodule Scheduler do
  def get_schedules do
    {:ok, raw} = File.read("./lib/config.json");
    {:ok, schedules} = Jason.decode(raw);
	Parser.get_schedule_from_map(schedules)
  end
end

defmodule Concurrency do
  def main do

    {:ok, schedules} = Scheduler.get_schedules

	_pids = Enum.map(schedules, fn schedule -> spawn_link(Concurrency, :match_schedule, [schedule]) end)

  end

  def match_schedule(schedule) do

    {:ok, scheduled} = NaiveDateTime.from_iso8601(schedule.scheduled)

    new_ndt = NaiveDateTime.local_now
    new_ndt = NaiveDateTime.add(new_ndt, -new_ndt.second)

    case scheduled do
      ^new_ndt ->
        IO.puts("Hello world from #{self()}")
        System.cmd("notify-send", [schedule.task])
      _ ->
        :timer.sleep(1000)
        match_schedule(schedule)
    end
    :ok
  end
end
