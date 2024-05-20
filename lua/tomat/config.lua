local notify = require("notify")

local M = {}

M.options = {}

local defaults = {
	session_time_in_minutes = 30,
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
	},
}

function M.setup(opts)
	-- Directly apply user options to M.options
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})

	M.instance = notify.instance({
		icons = { INFO = M.options.icon.in_progress, WARN = M.options.icon.done, ERROR = M.options.icon.done },
		timeout = M.options.notification.timeout,
	}, false)
end

return M
