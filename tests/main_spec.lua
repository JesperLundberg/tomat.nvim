-- Import necessary modules
local assert = require("luassert")
local stub = require("luassert.stub")

-- System under test (main)
local sut = require("lua.tomat.main")

describe("main", function()
	describe("start", function()
		it("should return true", function()
			local result = sut.start()

			assert.is_true(result)
		end)
	end)
end)
