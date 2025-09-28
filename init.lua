-- Set up lazy.nvim plugins
require("lazy").setup({
	-- Mason for managing LSP servers, linters, and formatters
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
		},
		automatic_enable = true,
	},

	-- None - LS
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier,
					--null_ls.builtins.completion.spell,
					--null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.formatting.rustfmt,
					--null_ls.builtins.diagnostics.clippy,
					null_ls.builtins.formatting.textlint,
				},
			})
		end,
	},
	-- TREE SITTER
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Recommended to update parsers on plugin update
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "python", "rust" }, -- Languages to always install
				sync_install = false, -- Install parsers asynchronously
				auto_install = true, -- Automatically install missing parsers on buffer open

				highlight = {
					enable = true, -- Enable Tree-sitter highlighting
					disable = { "yaml" }, -- Languages to disable highlighting for
				},
				indent = { enable = true }, -- Enable Tree-sitter based indentation
			})
		end,
	},
	-- CONFORM
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	-- STYLE
	{
		"rebelot/kanagawa.nvim",
		build = ":KanagawaCompile", -- Required for compilation
		opts = {
			compile = true,
			terminalColors = false, -- If you want custom terminal colors
		},
	},
	-- Blink.CMP
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-space>"] = {
					function(cmp)
						cmp.show({ providers = { "snippets" } })
					end,
				},
				["<Tab>"] = { "select_and_accept" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	-- Wakatime
	{ "wakatime/vim-wakatime", lazy = false },

	-- Icons
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	-- Lualine (Display Bar)
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Telescope File Browser
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	-- Tabby
	{
		"nanozuki/tabby.nvim",
		---@type TabbyConfig
		opts = {
			-- configs...
		},
	},
})
-- Conform Setup
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

-- Telescope File Browser Setup
require("telescope").setup({
	extensions = {
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
		},
	},
})

-- Scope
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:williamboman
require("telescope").load_extension("file_browser")
-- Keybinds
--  Alternatively, using lua API
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Space>ff", "<cmd>Telescope find_files<CR>", { buffer = true, noremap = true })
vim.keymap.set("n", "<Space>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<Space>fh", function()
	builtin.help_tags()
end, { desc = "Telescope help tags" })
vim.keymap.set("n", "<Space>fb", function()
	require("telescope").extensions.file_browser.file_browser()
end)

-- Tabby
vim.api.nvim_set_keymap("n", "<Space>tt", ":tabnew<CR>", {})
vim.api.nvim_set_keymap("n", "<Space>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Space>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Space>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Space>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<Space>tmp", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<Space>tmn", ":+tabmove<CR>", { noremap = true })

-- Terminal Intergration
-- Toggle terminal in right split
local term_win = nil
local term_buf = nil

-- Map Esc to leave terminal-insert mode quickly
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

vim.keymap.set("n", "<Space>ts", function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		-- If terminal is open, close it
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
	else
		-- Otherwise, open terminal in right split
		vim.cmd("rightbelow vsplit")
		term_win = vim.api.nvim_get_current_win()
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()

		-- Enter insert mode so you can type in terminal immediately
		vim.cmd("startinsert")
	end
end, { desc = "Toggle Terminal (Right Split)" })

-- Telescope
vim.keymap.set("n", "<Space>ff", "<cmd> Telescope find_files <CR>")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "`fb", builtin.buffers, { desc = "Telescope buffers" })
-- Tab Setup
vim.opt.sessionoptions = { -- required
	"buffers",
	"tabpages",
	"globals",
}

-- Set up Theme
vim.cmd("colorscheme kanagawa-dragon")

-- Set Up Tabs
require("tabby").setup({})
-- Save Tabs?
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
vim.o.showtabline = 2

-- Set Up Bottom Activity Line

-- define
require("lualine").setup({
	sections = {
		lualine_a = {
			"mode",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = true,
				always_visible = true,
			},
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			"vim.fn.getcwd()",
			"filename",
			"os.date('%Y-%m-%d %H:%M:%S')",
		},
		lualine_x = { -- LSP status (attached client name[s])
			function()
				local clients = vim.lsp.get_active_clients({ bufnr = 0 })
				if next(clients) == nil then
					return "No LSP"
				end
				local names = {}
				for _, client in pairs(clients) do
					table.insert(names, client.name)
				end
				return "  " .. table.concat(names, ", ")
			end,
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- Keybinds
-- Cargo Run
vim.keymap.set("n", "<Space>cr", ":tabnew | terminal cargo run", {})

-- Auto Enter NVIM Workspace
-- Auto-load session if `.editor/.vim` exists and no files were passed
vim.api.nvim_create_user_command("EnterSession", function()
	if vim.fn.argc() == 0 then
		local session_file = ".editor/editor.vim"
		if vim.fn.filereadable(session_file) == 1 then
			vim.cmd("silent! source " .. session_file)
		end
	end
end, {})

-- Command to save session into .editor/.editor.vim
vim.api.nvim_create_user_command("SaveSession", function()
	local session_dir = ".editor"
	local session_file = session_dir .. "/editor.vim"

	-- Create the directory if it doesn't exist
	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end

	-- Save the session
	vim.cmd("mksession! " .. session_file)
	print("Session saved to " .. session_file)
end, {})

-- Error Display
vim.diagnostic.config({
	virtual_text = false, -- Disable inline virtual text for diagnostics
	float = {
		focusable = false, -- Make the float window non-focusable by default
		border = "single", -- Add a border to the float window
		source = "always", -- Always show the source of the diagnostic
		header = "", -- No header for the float window
		prefix = "", -- No prefix for the diagnostic message
	},
})

-- Show line diagnostics automatically in hover window on CursorHold
vim.o.updatetime = 250 -- Time in ms to wait before triggering CursorHold
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "lua_ls" },
})
