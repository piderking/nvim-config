local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Space>ff", "<cmd>Telescope find_files<CR>", { buffer = true, noremap = true })
vim.keymap.set("n", "<Space>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<Space>fh", function()
	builtin.help_tags()
end, { desc = "Telescope help tags" })
vim.keymap.set("n", "<Space>fb", function()
	require("telescope").extensions.file_browser.file_browser()
end)

-- Error

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local function diagnostics_jump_to_correct_file()
	builtin.diagnostics({
		attach_mappings = function(prompt_bufnr, map)
			local function jump_to_diagnostic()
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				-- Determine buffer
				local bufnr = entry.bufnr
				if (not bufnr or not vim.api.nvim_buf_is_loaded(bufnr)) and entry.filename then
					bufnr = vim.fn.bufadd(entry.filename)
					vim.fn.bufload(bufnr)
				end

				-- Fallback: current buffer
				if not bufnr or not vim.api.nvim_buf_is_loaded(bufnr) then
					vim.notify("Cannot find buffer for diagnostic!", vim.log.levels.WARN)
					return
				end

				-- Determine line and column
				local line = entry.lnum or entry.row or 1
				local col = entry.col or entry.start_col or 0
				line = tonumber(line) or 1
				col = tonumber(col) or 0
				col = math.max(0, col - 1)

				-- Jump to buffer and position
				vim.api.nvim_set_current_buf(bufnr)
				vim.api.nvim_win_set_cursor(0, { line, col })
				vim.cmd("edit") -- ensure buffer shows
			end

			map("i", "<CR>", jump_to_diagnostic)
			map("n", "<CR>", jump_to_diagnostic)
			return true
		end,
	})
end

-- Bind to <Space>q
vim.keymap.set("n", "<Space>q", diagnostics_jump_to_correct_file, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
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

-- Define keymaps for the LSP features
local opts = { noremap = true, silent = true, buffer = bufnr }

-- Map <Space> K to the hover function (show documentation/type)
-- The 'desc' adds a description that can be seen with the 'which-key' plugin.

-- Optional: Add standard LSP keymaps for a full experience
-- Map gD to go to the declaration
vim.keymap.set("n", "<Space>gD", vim.lsp.buf.declaration, opts)
-- Map gd to go to the definition
vim.keymap.set("n", "<Space>gd", vim.lsp.buf.definition, opts)
-- Map gi to go to the implementation
vim.keymap.set("n", "<Space>gi", vim.lsp.buf.implementation, opts)
-- Map <leader>rn to rename a symbol
vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, opts)
-- Map <leader>ca to show code actions
vim.keymap.set({ "n", "v" }, "<Space>ca", vim.lsp.buf.code_action, opts)

--
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

vim.keymap.set("i", "<C-d>", "<C-o>$")

-- Telescope
vim.keymap.set("n", "<Space>ff", "<cmd> Telescope find_files <CR>")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "`fb", builtin.buffers, { desc = "Telescope buffers" })
