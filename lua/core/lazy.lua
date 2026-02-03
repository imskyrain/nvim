-- Lazy.nvim 加载文件lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"

	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local lite_mode = vim.env.NVIM_LITE == "1"

require("lazy").setup({
	spec = lite_mode and {
		{ import = "plugins.lite" },
	} or {
		{ import = "plugins" },
		{ import = "plugins.editor" },
		{ import = "plugins.git" },
		{ import = "plugins.lsp" },
		{ import = "plugins.navigation" },
		{ import = "plugins.ui" },
		{ import = "plugins.utils" },
	},
	checker = { enable = not lite_mode },
})
