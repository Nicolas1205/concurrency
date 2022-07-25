defmodule Schedule do
  defstruct id: nil, task: "", scheduled: ""
end

defmodule Parser do
  def get_schedule_from_map(schedules) do
	Enum.map schedules, fn(schedule) ->
	  schedule = Map.new schedule, fn({key,value}) ->
		{String.to_atom(key), value}
		end
	  {:ok, struct(Schedule, schedule)}
	 end
  end
end
