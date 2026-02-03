-- Lite模式极简插件组：仅语法高亮 + 主题
-- 启用方式：NVIM_LITE=1 nvim <file>
return {
	{
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({ style = "moon" })
		end,
		init = function()
			vim.cmd.colorscheme("tokyonight-moon")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"python", "javascript", "typescript", "lua", "rust", "go",
				"html", "css", "json", "yaml", "markdown", "markdown_inline",
				"bash", "vim", "vimdoc", "c", "cpp", "java", "toml",
			},
			auto_install = true,
		},
	},
}
