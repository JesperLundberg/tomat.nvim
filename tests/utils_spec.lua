-- Import necessary modules
local assert = require("luassert")

describe("utils", function()
	local sut = require("tomat.utils")

	describe("has_key", function()
		it("should return true if the key exists", function()
			-- Arrange
			local tbl = { key = "value" }

			-- Act
			local result = sut.has_key(tbl, "key")

			-- Assert
			assert.is_true(result)
		end)

		it("should return false if the key does not exist", function()
			-- Arrange
			local tbl = { key = "value" }

			-- Act
			local result = sut.has_key(tbl, "non_existent_key")

			-- Assert
			assert.is_false(result)
		end)

		it("should return false if the table is empty", function()
			-- Arrange
			local tbl = {}

			-- Act
			local result = sut.has_key(tbl, "key")

			-- Assert
			assert.is_false(result)
		end)
	end)

	describe("trim_whitespaces_and_newlines", function()
		it("should remove all starting and trailing whitespaces and newlines from the string", function()
			-- Arrange
			local str = "  \n string \n  "

			-- Act
			local result = sut.trim_whitespace_and_newlines(str)

			-- Assert
			assert.are.same("string", result)
		end)

		it(
			"should remove all starting and trailing whitespaces and newlines from the string but not inside the string",
			function()
				-- Arrange
				local str = "  \n string with whitespace in the sentence \n  "

				-- Act
				local result = sut.trim_whitespace_and_newlines(str)

				-- Assert
				assert.are.same("string with whitespace in the sentence", result)
			end
		)
	end)
end)
