return {
	"xiyaowong/transparent.nvim",
	-- Neovide 是 GUI，不需要透明插件
	enabled = not vim.g.neovide,
	config = function()
		require("transparent").setup({
			extra_groups = {
				"NormalFloat",
				"TelescopeNormal",
			},
		})
		-- Bufferline
		require("transparent").clear_prefix("BufferLine")
		require("transparent").clear_prefix("TabLine")

		-- Lualine
		require("transparent").clear_prefix("lualine")

		-- Neo-tree
		require("transparent").clear_prefix("NeoTree")

		-- Noice / Telescope
		require("transparent").clear_prefix("Noice")
		require("transparent").clear_prefix("Telescope")

		-- 部分主题在加载后会重新覆盖 Normal 的 bg，导致透明失效
		-- 监听 ColorScheme 事件，每次主题切换后重新清除背景
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalBg", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end,
		})
	end,
}
