# TODO: so we have to change to configuration of a certain schedule 
# which is concurrently running  
# so we get to kill and restart that process with the new config 

defmodule Schedule.Scheduler do 
	# @derive {Inspect, only: [:task]}
	# defstruct time: Schedule.Time, task: :nothing

	# So we have to run this process as supervisor 

	# schedule: Schedule
	def update_schedule(updated_schedule, pid) do 
		send pid, :update
		new_pid = spawn_link Concurrency, :match_schedule, [updated_schedule]
		Map.get_and_update(updated_schedule, :pid, new_pid)
		:ok
	end
end 

# on_days: [1,2,3,4,5,6,7]
# Date.day_of_wee ndt
# Map.has_key? 

defmodule Schedule.DB do 
	def get_schedules do 
		{_, raw} = File.read("./lib/config.json"); 
		schedules = Jason.decode(raw);
		schedules
	end
end

defmodule Concurrency do
  def main do
	
		{ok?, schedules} = Schedule.DB.get_schedules
		pids = [1]
		

		# TODO: Implement Agent for stateful pids var 
		case ok? do 
			:ok -> pids = Enum.map(schedules, fn schedule ->
					spawn_link(Concurrency, :match_schedule, [schedule]) end)
			_ -> 
				IO.puts(:stderr, "An error deserializing")
				:error
		end
  end

	# schedule: Schedule	
	def match_schedule(schedule) do 

		IO.puts("Trying Again")
		{ok?, ndt_scheduled} = NaiveDateTime.from_iso8601(schedule["scheduled"]) 

		#case ok? do  
		#	:error -> raise ArgumentError, "Error parsing schedule"
		#end

		new_ndt = NaiveDateTime.local_now
		trunc_ndt = NaiveDateTime.add(new_ndt, -new_ndt.second)

		case ndt_scheduled do 
			^trunc_ndt ->
				IO.puts("Hello world from #{schedule["task"]}")
				System.cmd("notify-send", [schedule["task"]])
			_ -> 
				:timer.sleep(1000)
				match_schedule(schedule)
		end

	#	receive do 
	#		:update -> Process.exit(self(), :kill) 
	#	end
		
	end
end
