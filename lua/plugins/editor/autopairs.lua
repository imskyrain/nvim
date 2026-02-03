return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({
			fast_wrap = {},
			-- blink.cmp 默认已经处理了括号闭合，禁用 autopairs 的重复闭合
			enable_afterfunc = false,
		})
	end,
}
