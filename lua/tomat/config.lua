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
}

M._options = nil

function M.setup(options)
	-- if vim.fn.has("nvim-0.8.0") == 0 then
	-- 	error("tomat needs Neovim >= 0.8.0.")
	-- end
	M._options = options

	-- Have neovim finished loading yet?
	if vim.api.nvim_get_vvar("vim_did_enter") == 0 then
		-- It has not so wait for it to finish and then setup
		vim.defer_fn(function()
			M._setup()
		end, 0)
	else
		M._setup()
	end
end

function M._setup()
	-- Override the default options with the user options
	M.options = vim.tbl_deep_extend("force", {}, defaults, M.options or {}, M._options or {})
end

return M
