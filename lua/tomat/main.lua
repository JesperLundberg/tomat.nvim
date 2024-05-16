local config = require("tomat.config")

local M = {}

local timer = nil

function M.start()
	print(vim.inspect(config))

	-- local duration_in_seconds = config.options.session_time_in_minutes * 60
	print("config.options.session_time_in_minutes" .. config.options.session_time_in_minutes)
	local duration_in_seconds = 5

	M.start_task(duration_in_seconds)
end

function M.start_task(duration_in_seconds)
	if timer then
		timer:stop() -- Ensure any existing timer is stopped
	end

	timer = vim.uv.new_timer()
	timer:start(
		duration_in_seconds * 1000, -- Timer wants duration in milliseconds
		0,
		vim.schedule_wrap(function()
			require("notify")("Pomodoro session ended!")
			-- print("Pomodoro session ended!")
			-- Add any other actions you want to trigger here
		end)
	)
end

function M.stop()
	if timer then
		timer:stop()
		require("notify")("Pomodoro session cancelled.")
		-- print("Pomodoro session cancelled.")
		timer = nil -- Clear the timer reference
	else
		require("notify")("No active Pomodoro session to cancel.")
		-- print("No active Pomodoro session to cancel.")
	end
end

function M.show()
	-- Add status display here
end

return M
