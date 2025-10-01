vim.api.nvim_create_user_command("WakaConfig", function()
	vim.cmd("edit " .. vim.fn.expand("~/.wakatime.cfg"))
end, { desc = "Edit WakaTime config" })

vim.api.nvim_create_user_command("zshconfig", function()
	vim.cmd("edit " .. vim.fn.expand("~/.zshrc"))
end, { desc = "Edit .zshrc" })
