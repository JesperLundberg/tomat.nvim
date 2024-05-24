local config = require("tomat.config")
local session = require("tomat.session")

local M = {}

local timer = nil
local time_when_done = nil

-- Start a new pomodoro session with a specific duration
-- @param duration_in_seconds
-- @param restarted_session
local function start_task(duration_in_seconds, restarted_session)
	if timer then
		timer:stop() -- Ensure any existing timer is stopped
	end

	-- Create a new timer
	timer = vim.uv.new_timer()

	-- Start the timer and notify the user when the session is done
	timer:start(
		duration_in_seconds * 1000, -- Timer wants duration in milliseconds
		0,
		vim.schedule_wrap(function()
			config.instance.notify("Pomodoro session ended!", vim.log.levels.ERROR, {
				title = config.options.notification.title,
				timeout = config.options.notification.timeout_on_timer_done,
			})
			time_when_done = nil
		end)
	)

	-- Set the time when the session will be done
	time_when_done = os.time() + duration_in_seconds

	-- Write the session timestamp to the file
	session.write_session(time_when_done)

	local start_message

	-- If the session was restarted, notify the user that the session was restarted
	if restarted_session then
		start_message = "Pomodoro session restarted. Time when done: " .. os.date("%Y-%m-%d %H:%M:%S", time_when_done)
	else
		start_message = "Pomodoro session started. Time when done: " .. os.date("%Y-%m-%d %H:%M:%S", time_when_done)
	end

	-- Notify the user that the session has started
	config.instance.notify(start_message, vim.log.levels.INFO, { title = config.options.notification.title })
end

-- Start a new pomodoro session
function M.start()
	-- Get the session timestamp (if it exists)
	local session_timestamp = session.read_session()

	local duration_in_seconds
	local restarted_session

	if session_timestamp then
		-- Get the number of seconds left in the session
		duration_in_seconds = os.difftime(session_timestamp, os.time())
		restarted_session = true
	else
		duration_in_seconds = config.options.session_time_in_minutes * 60
		restarted_session = false
	end

	-- Create a new pomodoro session
	start_task(duration_in_seconds, restarted_session)
end

-- Stop the current pomodoro session
function M.stop()
	if timer then
		-- Stop the timer
		timer:stop()

		-- Notify the user that the session has been cancelled
		config.instance.notify(
			"Pomodoro session cancelled.",
			vim.log.levels.WARN,

			{ title = config.options.notification.title }
		)

		-- Reset the timer and time_when_done
		timer = nil
		time_when_done = nil

		-- Clear the session timestamp in the file
		session.write_session(0)
	else
		-- Notify the user that there is no active session to cancel
		config.instance.notify(
			"No active Pomodoro session to cancel.",
			vim.log.levels.WARN,
			{ title = config.options.notification.title }
		)
	end
end

-- Show the current pomodoro session status
function M.show()
	-- Make sure that the timer has not passed
	if timer and time_when_done and os.time() > time_when_done then
		-- Stop the timer abd reset the timer and time_when_done
		timer:stop()
		timer = nil
		time_when_done = nil
	end

	-- Check if there is an active session
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
