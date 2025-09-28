
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "lua_ls" },
	automatic_enable = true
})

