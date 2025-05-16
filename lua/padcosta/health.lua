local M = {}

function M.check()
	local query = require("padcosta.query")
	vim.health.start("padcosta.nvim")

	-- Neovim version check

	if vim.fn.has("nvim-0.9.0") == 1 then
		vim.health.ok("Neovim 0.9+ detected")
	else
		vim.health.error("Requires Neovim 0.9+")
	end

	-- Query availability check
	local langs = query.list_installed()

	if #langs > 0 then
		vim.health.ok(string.format("Found queries for: %s", table.concat(langs, ", ")))
	else
		vim.health.warn("No query files found in runtimepath")
	end
end

return M
