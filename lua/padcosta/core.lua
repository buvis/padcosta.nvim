local api = vim.api
local query = require("padcosta.query")

local M = {}

local function process_buffer(buf, parser, q)
	local root = parser:parse()[1]:root()
	local changes = {}

	for _, node in q:iter_captures(root, buf, 0, -1) do
		local start_line = node:start()
		local prev_line = api.nvim_buf_get_lines(buf, start_line - 1, start_line, false)[1]

		if prev_line and prev_line:match("^%s*$") == nil then
			table.insert(changes, start_line)
		end
	end

	-- Apply changes in reverse order

	if #changes > 0 then
		for i = #changes, 1, -1 do
			api.nvim_buf_set_lines(buf, changes[i], changes[i], false, { "" })
		end
	end
end

function M.setup()
	api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			local buf = api.nvim_get_current_buf()
			local ft = vim.bo[buf].filetype

			if ft == "" then
				return
			end

			-- Validate parser exists
			local parser = vim.treesitter.get_parser(buf)

			if not parser then
				return
			end

			-- Get validated query
			local q = query.get(ft)

			if not q then
				return
			end

			process_buffer(buf, parser, q)
		end,
	})
end

return M
