local uv = vim.loop
local base_path = vim.fn.stdpath("config") .. "/plugins"

-- Make sure the folder exists
local stat = uv.fs_stat(base_path)
if stat and stat.type == "directory" then
	local handle = uv.fs_scandir(base_path)
	if handle then
		while true do
			local name, type = uv.fs_scandir_next(handle)
			if not name then
				break
			end
			if type == "directory" then
				vim.opt.rtp:append(base_path .. "/" .. name)
			end
		end
	end
end
-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
-- lua/loader.lua
local uv = vim.loop
local base_path = vim.fn.stdpath("config") .. "/lua"

local function require_all(path, prefix)
	prefix = prefix or ""
	local stat = uv.fs_stat(path)
	if not stat or stat.type ~= "directory" then
		return
	end

	local handle = uv.fs_scandir(path)
	if not handle then
		return
	end

	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then
			break
		end
		local full_path = path .. "/" .. name
		if type == "file" and name:sub(-4) == ".lua" then
			local module_name = prefix .. name:sub(1, -5) -- remove ".lua"
			pcall(require, module_name)
		elseif type == "directory" then
			require_all(full_path, prefix .. name .. ".")
		end
	end
end

-- Load all Lua files under lua/
require_all(base_path)
