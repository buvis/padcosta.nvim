local M = {
	debug = false,
}

function M.setup(opts)
	opts = opts or {}
	M.debug = opts.debug or false
	require("padcosta.core").setup()
end

return M
