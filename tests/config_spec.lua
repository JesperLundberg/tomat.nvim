-- Import necessary modules
local assert = require("luassert")
local stub = require("luassert.stub")

-- System under test (main)
local sut = require("tomat.config")

describe("config", function()
	local notify_stub
	local read_session_stub

	before_each(function()
		notify_stub = stub(require("notify"), "instance")
		read_session_stub = stub(require("tomat.session"), "read_session")
	end)

	after_each(function()
		if notify_stub then
			notify_stub:revert()
		end
		if read_session_stub then
			read_session_stub:revert()
		end
	end)

	describe("setup", function()
		it("should override default values with supplied values", function()
			notify_stub.returns({
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
				persist = {
					enabled = false,
					file = vim.fn.stdpath("data") .. "/tomat_session.json",
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
					timeout_on_timer_done = 600000,
				},
				icon = {
					in_progress = "",
					done = "",
				},
				persist = {
					enabled = false,
					file = vim.fn.stdpath("data") .. "/tomat_session.json",
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
				session_time_in_minutes = 25,
				automatic = {
					create_a_new_session = false,
					break_time_in_minutes = 5,
				},

				notification = {
					title = "Tomat",
					timeout = 10000,
					timeout_on_timer_done = 600000,
				},
				icon = {
					in_progress = "",
					done = "",
				},
				persist = {
					enabled = true,
					file = vim.fn.stdpath("data") .. "/tomat_session.json",
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
					timeout_on_timer_done = 600000,
				},
				icon = {
					in_progress = "",
					done = "",
				},
				persist = {
					enabled = true,
					file = vim.fn.stdpath("data") .. "/tomat_session.json",
				},
			}, sut.options)
		end)

		it("should call notify.instance", function()
			sut.setup()

			assert.stub(notify_stub).was_called_with({
				icons = { INFO = "", WARN = "", ERROR = "" },
				timeout = 10000,
			}, false) -- false is if the global config for notify should be used
		end)
	end)
end)
