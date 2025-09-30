-- Bootstrap lazy.nvim if not installed

local lazypath = vim.fn.stdpath("config") .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Automatically load all local plugin folders in ~/.config/nvim/plugins
local plugins_dir = vim.fn.stdpath("config") .. "/plugins"
local plugin_specs = {
	{
		"lervag/vimtex",
		lazy = false, -- load immediately (important for filetype detection)
		init = function()
			-- Use latexmk with XeLaTeX
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-xelatex", -- 👈 force XeLaTeX
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}

			-- Viewer: set to zathura (or your preferred PDF viewer)
			vim.g.vimtex_view_method = "zathura"
		end,
	},
}

-- Iterate over each subfolder in plugins_dir
for _, name in ipairs(vim.fn.readdir(plugins_dir)) do
	local path = plugins_dir .. "/" .. name
	if vim.loop.fs_stat(path .. "/.git") or vim.loop.fs_stat(path .. "/plugin") then
		table.insert(plugin_specs, { dir = path })
	end
end
-- Setup lazy.nvim with all detected local plugins
require("lazy").setup(plugin_specs)

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
