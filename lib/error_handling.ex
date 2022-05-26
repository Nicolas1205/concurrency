defmodule Example do 
	def listen do 
		receive do 
			{:ok, msg} ->
				IO.puts(msg)
				{:ok, msg}
			:error ->
				IO.puts("An error ocurred") 
				{:error, "Unknown"}
		end

		listen()
	end

	def explode, do: exit(:explosion)

	def run do 
		Process.flag :trap_exit, true
		spawn_link Example, :explode, []
			
		receive do 
			{:EXIT, _from_pid, reason} -> IO.puts("Exit reason: #{reason}") 
		end

	end
	
end









