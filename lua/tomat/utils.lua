local M = {}

-- find out if table has the provided key
-- @param tab table
-- @param val string
-- @return bool
function M.has_key(tab, val)
	if tab == nil then
		return false
	end

	for key, _ in pairs(tab) do
		if key == val then
			return true
		end
	end

	return false
end

-- Trim leading and trailing whitespaces and newlines
-- @param str string
-- @return string
function M.trim_whitespace_and_newlines(str)
	-- Remove leading and trailing whitespaces
	str = str:gsub("^%s*(.-)%s*$", "%1")
	-- Remove leading and trailing newlines
	str = str:gsub("^%n*(.-)%n*$", "%1")

	return str
end

return M
