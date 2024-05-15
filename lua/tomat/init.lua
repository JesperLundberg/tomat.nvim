-- Available commands for ProjektGunnar
local commands = {
	["start"] = function()
		require("tomat.main").start(5)
	end,
	["stop"] = function()
		require("tomat.main").stop()
	end,
}

local function tab_completion(_, _, _)
	-- Tab completion for ProjektGunnar
	local tab_commands = {}

	-- Loop through the commands and add the key value to the tab completion
	for k, _ in pairs(commands) do
		table.insert(tab_commands, k)
	end

	return tab_commands
end

vim.api.nvim_create_user_command("Tomat", function(opts)
	-- If the command exists then run the corresponding function
	commands[opts.args]()
end, { nargs = "*", complete = tab_completion, desc = "Tomat plugin" })
