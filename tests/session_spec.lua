-- Import necessary modules
local assert = require("luassert")
local stub = require("luassert.stub")

describe("session", function()
	local sut = require("tomat.session")

	local fs_open_stub
	local fs_fstat_stub
	local fs_read_stub
	local fs_close_stub
	local fs_write_stub

	require("tomat.config").options = {
		persist = {
			file = "tomat_session.json",
		},
	}

	before_each(function()
		fs_open_stub = stub(vim.uv, "fs_open")
		fs_fstat_stub = stub(vim.uv, "fs_fstat")
		fs_read_stub = stub(vim.uv, "fs_read")
		fs_close_stub = stub(vim.uv, "fs_close")
		fs_write_stub = stub(vim.uv, "fs_write")
	end)

	after_each(function()
		if fs_open_stub then
			fs_open_stub:revert()
		end

		if fs_fstat_stub then
			fs_fstat_stub:revert()
		end

		if fs_read_stub then
			fs_read_stub:revert()
		end

		if fs_close_stub then
			fs_close_stub:revert()
		end

		if fs_write_stub then
			fs_write_stub:revert()
		end
	end)

	describe("read_session", function()
		it("should return nil if the file does not exist", function()
			-- Arrange
			fs_open_stub.returns(nil)

			-- Act
			local result = sut.read_session()

			-- Assert
			assert.is_nil(result)
		end)

		it("should return the content of the file", function()
			-- Arrange
			local expected_timestamp = os.time() + 1000

			fs_open_stub.returns(1)
			fs_fstat_stub.returns({ size = 10 })
			fs_read_stub.returns('{"timestamp": ' .. expected_timestamp .. "}\n")
			fs_close_stub.returns()

			-- Act
			local result = sut.read_session()

			-- Assert
			assert.are.equal(expected_timestamp, result)
		end)

		it("should return nil if the file content is empty", function()
			-- Arrange
			fs_open_stub.returns(1)
			fs_fstat_stub.returns({ size = 10 })
			fs_read_stub.returns("{}\n")
			fs_close_stub.returns()

			-- Act
			local result = sut.read_session()

			-- Assert
			assert.is_nil(result)
		end)

		it("should return nil if the timestamp has already passed", function()
			-- Arrange
			local expected_timestamp = os.time() - 1000

			fs_open_stub.returns(1)
			fs_fstat_stub.returns({ size = 10 })
			fs_read_stub.returns('{"timestamp": ' .. expected_timestamp .. "}\n")
			fs_close_stub.returns()

			-- Act
			local result = sut.read_session()

			-- Assert
			assert.is_nil(result)
		end)
	end)

	describe("write_session", function()
		it("should write the timestamp to the file", function()
			-- Arrange
			local expected_timestamp = os.time() + 1000

			fs_open_stub.returns(1)
			fs_write_stub.returns(1)
			fs_close_stub.returns()

			-- Act
			sut.write_session(expected_timestamp)

			-- Assert
			assert.stub(fs_open_stub).was_called_with("tomat_session.json", "w", 438)
			assert.stub(fs_write_stub).was_called_with(1, '{"timestamp": ' .. expected_timestamp .. "}", 0)
			assert.stub(fs_close_stub).was_called_with(1)
		end)
	end)
end)
