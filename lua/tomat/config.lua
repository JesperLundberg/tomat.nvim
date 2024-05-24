local notify = require("notify")

local M = {}

M.options = {}

local defaults = {
	session_time_in_minutes = 25,
	automatic = {
		create_a_new_session = false,
		break_time_in_minutes = 5,
	},
	icon = {
		in_progress = "",
		done = "",
	},
	notification = {
		title = "Tomat",
		timeout = 10000, -- 10 seconds
		timeout_on_timer_done = 600000, -- 10 minutes
	},
	persist = {
		enabled = true,
		file = vim.fn.stdpath("data") .. "/tomat_session.json",
	},
}

function M.setup(opts)
	-- Directly apply user options to M.options
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})

	-- Create a new instance of notify with some tomat.nvim standards and set it to M.instance
	M.instance = notify.instance({
		icons = { INFO = M.options.icon.in_progress, WARN = M.options.icon.done, ERROR = M.options.icon.done },
		timeout = M.options.notification.timeout,
	}, false)

	if M.options.persist.enabled then
		-- Read the session timestamp from the file
		local session_timestamp = require("tomat.session").read_session()

		-- If there is no session timestamp or if the session has expired, do nothing
		if session_timestamp and os.difftime(session_timestamp, os.time()) > 0 then
			require("tomat.main").start()
		end
	end
end

return M
