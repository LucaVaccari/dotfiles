return {
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({
				virtual_text = false,
			})
		end,
	},
	{
		"roobert/action-hints.nvim",
		config = function()
			require("action-hints").setup({
				template = {
					definition = { text = " ⊛", color = "#add8e6" },
					references = { text = " ↱%s", color = "#ff6666" },
				},
				use_virtual_text = true,
			})
		end,
	},
}
