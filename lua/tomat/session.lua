local async = require("plenary.async")
local path = require("plenary.path")

local M = {}

-- Open the file in read mode
-- @param path_to_session_file
-- @return file
local function open_file(path_to_session_file)
	-- Attempt to open the file
	local ok, fd, err_msg = pcall(async.uv.fs_open, path, "r", 438)
	if not ok then
		-- Check if the error is specifically due to the file not existing
		if err_msg == "ENOENT" then
			-- Use plenary.path to create an empty file
			local file_path = path:new(path_to_session_file)
			file_path:write("{}") -- Writes an empty json object to the file, effectively creating an empty file

			return nil -- Return nil as there was no saved data
		else
			-- There should be no errors but if there are, print the error message
			print("An unexpected error occurred:", err_msg)
			return nil
		end
	end

	-- Read the file size and then read the entire file
	local _, stat = async.uv.fs_fstat(fd)
	local _, data = async.uv.fs_read(fd, stat.size, 0)

	-- Close the file without throwing an error if it fails as we cannot do anything about it
	local _, _ = pcall(async.uv.fs_close, fd)

	return data
end

-- Read the session from the file
-- @return timestamp
function M.read_session()
	-- Get the path to the session file FIXME: Read this from config instead!
	local path_to_session_file = vim.fn.stdpath("data") .. "/tomat.json"

	-- Open the file and read the content
	local file_content = open_file(path_to_session_file)

	-- Decode the json content
	local json = vim.fn.json_decode(file_content)

	-- Return the timestamp of the session only if it has not already passed
	if json.timestamp < os.time() then
		return nil
	end

	-- Return the timestamp
	return json.timestamp
end

return M
