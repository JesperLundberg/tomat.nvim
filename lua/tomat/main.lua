local config = require("tomat.config")

local M = {}

local timer = nil
local time_when_done = nil

function M.start()
	local duration_in_seconds = config.options.session_time_in_minutes * 60

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
			config.instance.notify(
				"Pomodoro session ended!",
				vim.log.levels.ERROR,
				{ title = config.options.notification.title }
			)
			time_when_done = nil
		end)
	)

	time_when_done = os.time() + duration_in_seconds
	config.instance.notify(
		"Pomodoro session started. Time when done: " .. os.date("%Y-%m-%d %H:%M:%S", time_when_done),
		vim.log.levels.INFO,
		{ title = config.options.notification.title }
	)
end

function M.stop()
	if timer then
		timer:stop()
		config.instance.notify(
			"Pomodoro session cancelled.",
			vim.log.levels.WARN,

			{ title = config.options.notification.title }
		)
		timer = nil -- Clear the timer reference
		time_when_done = nil
	else
		config.instance.notify(
			"No active Pomodoro session to cancel.",
			vim.log.levels.WARN,
			{ title = config.options.notification.title }
		)
	end
end

function M.show()
	-- Add status display here
	if timer then
		config.instance.notify(
			"Pomodoro session active. Time when done: " .. os.date("%Y-%m-%d %H:%M:%S", time_when_done),
			vim.log.levels.INFO,
			{ title = config.options.notification.title }
		)
	else
		config.instance.notify(
			"No active Pomodoro session.",
			vim.log.levels.WARN,
			{ title = config.options.notification.title }
		)
	end
end

return M
