local config = vim.fn.stdpath("config")
for _, plugin in ipairs({
    "nvim-lspconfig",
    "mason.nvim",
    "mason-lspconfig.nvim",
    "blink.cmp",
    "conform.nvim",
    "friendly-snippets",
    "kanagawa.nvim",
    "lualine.nvim",
    "none-ls.nvim",




}) do
    vim.opt.rtp:append(config .. "/" .. plugin)
end

-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "lua_ls" },
})
