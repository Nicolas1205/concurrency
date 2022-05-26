defprotocol Utility do 
	@spec type(t) :: String.t() 
	def type(value)
end

defimpl Utility, for: BitString do 
	def type(_value), do: "String"
end

defimpl Utility, for: Integer do 
	def type(value), do: value
end


defmodule Scheduler do 
	# @derive {Inspect, only: [:task]}
	# defstruct time: Schedule.Time, task: :nothing
	
	def update(ndt) do 
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

defmodule Schedule.Time do 
	@enforce_keys [:hour,:minute]
	defstruct hour: :nothing, minute: :nothing
end

defmodule Concurrency do
  def main do
	
		{ok?, schedules} = Schedule.DB.get_schedules

		case ok? do 
			:ok -> Enum.map(schedules, fn schedule ->  spawn(Concurrency, :match_schedule, [schedule]) end)
			_ -> IO.puts(:stderr, "An error deserializing")
		end

  end

	# ndt: Schedule	
	def match_schedule(ndt) do 
		IO.puts("Trying Again")
		{ok?, ndt_scheduled} = NaiveDateTime.from_iso8601(ndt["scheduled"]) 

		new_ndt = NaiveDateTime.local_now
		trunc_ndt = NaiveDateTime.add(new_ndt, -new_ndt.second)

		case ndt_scheduled do 
			^trunc_ndt ->
				IO.puts("Hello world from #{ndt["task"]}")
				System.cmd("notify-send", [ndt["task"]])
			_ -> 
				:timer.sleep(1000)
				match_schedule(ndt)
		end
	end

end
