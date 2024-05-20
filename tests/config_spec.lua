-- Import necessary modules
local assert = require("luassert")
local stub = require("luassert.stub")

-- System under test (main)
local sut = require("lua.tomat.config")

describe("config", function()
	local notifyStub

	before_each(function()
		notifyStub = stub(require("notify"), "instance")
	end)

	after_each(function()
		if notifyStub then
			notifyStub:revert()
		end
	end)

	describe("setup", function()
		it("should override default values with supplied values", function()
			notifyStub.returns({
				notify = {},
			})

			-- Override all default values
			sut.setup({
				session_time_in_minutes = 60,
				automatic = {
					create_a_new_session = true,
					break_time_in_minutes = 10,
				},
				notification = {
					title = "Tomat",
					timeout = 10000,
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
				notification = {
					title = "Tomat",
					timeout = 10000,
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
				notification = {
					title = "Tomat",
					timeout = 10000,
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

				notification = {
					title = "Tomat",
					timeout = 10000,
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
				notification = {
					title = "Tomat",
					timeout = 10000,
				},
				icon = {
					in_progress = "",
					done = "",
				},
			}, sut.options)
		end)

		it("should call notify.instance", function()
			sut.setup()

			assert.stub(notifyStub).was_called_with({
				icons = { INFO = "", WARN = "", ERROR = "" },
				timeout = 10000,
			}, false) -- false is if the global config for notify should be used
		end)
	end)
end)
