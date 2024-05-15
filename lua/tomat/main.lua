local M = {}
local timer = nil

function M.start()
	local duration_in_seconds = 5 -- Read this from the setup

	M.start_task(duration_in_seconds)
end

function M.start_task(duration_in_seconds)
	if timer then
		timer:stop() -- Ensure any existing timer is stopped
	end

	timer = vim.uv.new_timer()
	timer:start(
		duration_in_seconds * 1000,
		0,
		vim.schedule_wrap(function()
			print("Pomodoro session ended!")
			-- Add any other actions you want to trigger here
		end)
	)
end

function M.stop()
	if timer then
		timer:stop()
		print("Pomodoro session cancelled.")
		timer = nil -- Clear the timer reference
	else
		print("No active Pomodoro session to cancel.")
	end
end

return M
