return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
    {
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				-- https://github.com/williamboman/mason-lspconfig.nvim
				ensure_installed = { "bashls", "cssls", "hyprls", "lua_ls" }
			})
		end
	},
    {
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.bashls.setup({})
			lspconfig.cssls.setup({})
			lspconfig.hyprls.setup({})
			lspconfig.lua_ls.setup({})

			-- Hyprlang LSP
			vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
					pattern = {"*.hl", "hypr*.conf"},
					callback = function(event)
							print(string.format("starting hyprls for %s", vim.inspect(event)))
							vim.lsp.start {
									name = "hyprlang",
									cmd = {"hyprls"},
									root_dir = vim.fn.getcwd(),
							}
					end
			})
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
			vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
		end
	}
}
