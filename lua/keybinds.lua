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

vim.keymap.set("i", "<C-d>", "<C-o>$")

-- Telescope
vim.keymap.set("n", "<Space>ff", "<cmd> Telescope find_files <CR>")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "`fb", builtin.buffers, { desc = "Telescope buffers" })
