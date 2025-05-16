local M = {}
local uv = vim.uv or vim.loop

local function is_dir(path)
	local stat = uv.fs_stat(path)
	return stat and stat.type == "directory"
end

local function scandir(path)
	local files = {}
	local fd = uv.fs_opendir(path, nil, 100)

	if not fd then
		return files
	end

	while true do
		local ents, err = uv.fs_readdir(fd)

		if err then
			break
		end

		if not ents then
			break
		end

		for _, ent in ipairs(ents) do
			table.insert(files, ent.name)
		end
	end

	uv.fs_closedir(fd)
	return files
end

function M.get(lang)
	local ok, query = pcall(vim.treesitter.query.get, lang, "padcosta")

	if not ok or not query then
		if require("padcosta").debug then
			vim.notify(
				string.format(
					"[padcosta] Query check failed for '%s' (schema found: %s)",
					lang,
					tostring(M.query_exists(lang))
				),
				vim.log.levels.DEBUG
			)
		end
		return nil
	end
	return query
end

function M.query_exists(lang)
	for _, rt in ipairs(vim.api.nvim_list_runtime_paths()) do
		local query_file = rt .. "/queries/" .. lang .. "/padcosta.scm"
		local stat = uv.fs_stat(query_file)

		if stat and stat.type == "file" then
			return true
		end
	end
	return false
end

function M.list_installed()
	local langs = {}
	local seen = {}

	for _, rt in ipairs(vim.api.nvim_list_runtime_paths()) do
		local queries_path = rt .. "/queries"

		if is_dir(queries_path) then
			for _, entry in ipairs(scandir(queries_path)) do
				local lang_path = queries_path .. "/" .. entry
				local query_file = lang_path .. "/padcosta.scm"

				if is_dir(lang_path) and uv.fs_stat(query_file) then
					if not seen[entry] then
						table.insert(langs, entry)
						seen[entry] = true
					end
				end
			end
		end
	end

	return langs
end

return M
