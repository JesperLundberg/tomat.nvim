-- local path = require("plenary.path")
local config = require("tomat.config")

local uv = vim.uv

local M = {}

local function open_file_and_write_content(path_to_session_file, content)
	-- FIXME: Check that the folder exists and create it if it doesn't

	-- Open the file
	local fd = uv.fs_open(path_to_session_file, "w", 438) -- 438 corresponds to O_WRONLY flag
	if not fd then
		error("Failed to open file")
	end

	-- Write the content to the file
	local written = uv.fs_write(fd, content, 0)
	if not written then
		error("Failed to write to file")
	end

	-- Close the file descriptor
	uv.fs_close(fd)
end

local function open_file_and_read_content(path_to_session_file)
	-- Open the file
	local fd = uv.fs_open(path_to_session_file, "r", 0) -- 0 corresponds to O_RDONLY flag
	if not fd then
		error("Failed to open file")
	end

	-- Get file stats to determine size
	local stat = uv.fs_fstat(fd)
	if not stat then
		error("Failed to get file stats")
	end

	-- Read the entire file content
	local data = uv.fs_read(fd, stat.size, 0)
	if not data then
		error("Failed to read file")
	end

	-- Close the file descriptor
	uv.fs_close(fd)

	return data
end

function M.write_session(timestamp)
	-- Get the path to the session file
	local path_to_session_file = config.options.persist.file

	-- Encode the timestamp as json
	local json = vim.fn.json_encode({ timestamp = timestamp })

	-- Write the json to the file
	open_file_and_write_content(path_to_session_file, json)
end

-- Read the session from the file
-- @return timestamp
function M.read_session()
	-- Get the path to the session file
	local path_to_session_file = config.options.persist.file
	local file_content = open_file_and_read_content(path_to_session_file)

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
