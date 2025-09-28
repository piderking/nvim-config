-- lua/plugin/blink-cmp-config.lua

local status_ok, blink = pcall(require, "blink")
if not status_ok then
	vim.notify("blink plugin not found")
	return
end

blink.setup({
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
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = false },
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})
