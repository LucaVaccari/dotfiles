return {
	"nvimtools/none-ls.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.markdownlint,
				null_ls.builtins.code_actions.refactoring,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			command = "lua vim.lsp.buf.format()",
		})
	end,
}
