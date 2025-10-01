local wakatime_cache = {
	value = "",
	last_update = 0,
}

local function wakatime_status()
	local now = os.time()
	if now - wakatime_cache.last_update >= 60 then
		-- Run CLI and update cache
		local handle = io.popen("wakatime-cli --today")
		if handle then
			local result = handle:read("*a")
			handle:close()
			wakatime_cache.value = " " .. (result:gsub("\n", ""))
			wakatime_cache.last_update = now
		end
	end
	return wakatime_cache.value
end

-- Track recent pressed keys
local recent_keys = {}
local timeout_ms = 3000 -- per key
local max_keys = 3

-- helper: remove expired keys
local function prune_keys()
	local now = vim.loop.now()
	local new_list = {}
	for _, entry in ipairs(recent_keys) do
		if now - entry.time < timeout_ms then
			table.insert(new_list, entry)
		end
	end
	recent_keys = new_list
end

-- helper: add key
local function add_key(k)
	local now = vim.loop.now()
	-- add new key entry
	table.insert(recent_keys, { key = k, time = now })

	-- cap list length
	if #recent_keys > max_keys then
		table.remove(recent_keys, 1) -- drop oldest
	end
end

-- ignore mouse keys
local mouse_keys = {
	"<LeftMouse>",
	"<RightMouse>",
	"<MiddleMouse>",
	"<ScrollWheelUp>",
	"<ScrollWheelDown>",
	"<ScrollWheelLeft>",
	"<ScrollWheelRight>",
	"<LeftDrag>",
	"<RightDrag>",
	"<MiddleDrag>",
	"<LeftRelease>",
	"<RightRelease>",
	"<MiddleRelease>",
}

local mouse_lookup = {}
for _, m in ipairs(mouse_keys) do
	mouse_lookup[m] = true
end

-- on_key callback
vim.on_key(
	vim.schedule_wrap(function(key)
		local k = vim.fn.keytrans(key)

		if mouse_lookup[k] then
			return -- skip mouse
		end

		add_key(k)
		prune_keys()
		vim.cmd("redrawstatus")
	end),
	vim.api.nvim_create_namespace("luastatus-keys")
)

-- auto prune periodically so old keys disappear
local timer = vim.loop.new_timer()
timer:start(
	1000,
	1000,
	vim.schedule_wrap(function()
		prune_keys()
		vim.cmd("redrawstatus")
	end)
)

-- clear on command end (ex-commands)
vim.api.nvim_create_autocmd("CmdlineLeave", {
	callback = function()
		recent_keys = {}
		vim.cmd("redrawstatus")
	end,
})

-- also clear when returning to normal mode
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:n",
	callback = function()
		recent_keys = {}
		vim.cmd("redrawstatus")
	end,
})

-- lualine component
local function key_component()
	prune_keys()
	if #recent_keys == 0 then
		return ""
	end
	local parts = {}
	for _, entry in ipairs(recent_keys) do
		table.insert(parts, entry.key)
	end
	return " " .. table.concat(parts, " ")
end

-- define
require("lualine").setup({
	options = {
		-- theme = "auto",
		section_separators = "",
		component_separators = "|",
	},
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
			{ wakatime_status }, -- WakaTime component
		},
		lualine_x = { -- LSP status (attached client name[s])
			key_component,
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
