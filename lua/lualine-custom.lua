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
