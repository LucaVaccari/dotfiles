return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- ensure_installed = { "bash", "css", "hyprlang", "lua", "markdown" },
			auto_install = true,
			sync_install = false,
			hightlight = { enable = true },
			indent = { enable = true },
		})

		vim.filetype.add({
			pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
		})
	end,
}
