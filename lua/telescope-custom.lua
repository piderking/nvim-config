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
