-- Error Display
--vim.diagnostic.config({
--	virtual_text = false, -- Disable inline virtual text for diagnostics
--	float = {
--		focusable = false, -- Make the float window non-focusable by default
--		border = "single", -- Add a border to the float window
--		source = "always", -- Always show the source of the diagnostic
--		header = "", -- No header for the float window
--		prefix = "", -- No prefix for the diagnostic message
--	},
--})
vim.keymap.set("n", "<Space><Left>", vim.diagnostic.goto_prev, { buffer = bufnr })
vim.keymap.set("n", "<Space><Right>", vim.diagnostic.goto_next, { buffer = bufnr })
-- Show line diagnostics automatically in hover window on CursorHold
vim.o.updatetime = 250 -- Time in ms to wait before triggering CursorHold
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Lines
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
vim.o.showtabline = 2
