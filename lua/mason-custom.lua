require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "lua_ls" },
	automatic_enable = true,
})

-- Set Hover
--vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0, desc = "LSP Hover" })
