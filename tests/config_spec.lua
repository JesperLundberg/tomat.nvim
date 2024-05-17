-- Import necessary modules
local assert = require("luassert")

-- System under test (main)
local sut = require("lua.tomat.config")

describe("config", function()
	describe("setup", function()
		it("should override default values with supplied values", function()
			-- Override all default values
			sut.setup({
				session_time_in_minutes = 60,
				automatic = {
					create_a_new_session = true,
					break_time_in_minutes = 10,
				},
				icon = {
					in_progress = "",
					done = "",
				},
			})

			-- Check if the default values are overridden
			assert.are.same({
				session_time_in_minutes = 60,
				automatic = {
					create_a_new_session = true,
					break_time_in_minutes = 10,
				},
				icon = {
					in_progress = "",
					done = "",
				},
			}, sut.options)
		end)

		it("should not override default values with nil", function()
			-- Override all default values with nil
			sut.setup({
				session_time_in_minutes = nil,
				automatic = {
					create_a_new_session = nil,
					break_time_in_minutes = nil,
				},
				icon = {
					in_progress = nil,
					done = nil,
				},
			})

			-- Check if the default values are not overridden
			assert.are.same({
				session_time_in_minutes = 30,
				automatic = {
					create_a_new_session = false,
					break_time_in_minutes = 5,
				},
				icon = {
					in_progress = "",
					done = "",
				},
			}, sut.options)
		end)

		it("should override only the supplied values", function()
			-- Override only the supplied values
			sut.setup({
				session_time_in_minutes = 60,
			})

			-- Check if the default values are overridden
			assert.are.same({
				session_time_in_minutes = 60,
				automatic = {
					create_a_new_session = false,
					break_time_in_minutes = 5,
				},
				icon = {
					in_progress = "",
					done = "",
				},
			}, sut.options)
		end)
	end)
end)
