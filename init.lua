-- 自定义全局变量Cook
-- _G.Cook = {}

-- 核心基础配置
require("core.autocmd")
require("core.basic")
require("core.keymap")
require("core.lazy") -- 加载Lazy.nvim

-- Lite模式：极简配置，适合临时编辑
if vim.env.NVIM_LITE then
	vim.opt.signcolumn = "no"
	vim.opt.colorcolumn = {}
end

-- 功能配置
-- Lite模式跳过主题切换
if not vim.env.NVIM_LITE then
	require("features.switch-theme").setup() -- 安装主题后应该在features文件夹下的theme-list.lua主题列表维护
end

--检测是否是neovide启动，使用neovide配置
if vim.g.neovide then
	require("neovide.basic")
	require("neovide.keymap")
end
