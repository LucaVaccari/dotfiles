return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				-- https://github.com/williamboman/mason-lspconfig.nvim
				ensure_installed = {
					"arduino_language_server",
					"bashls",
					"clangd",
					"cssls",
					"hyprls",
					"lua_ls",
					"taplo",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.arduino_language_server.setup({
				filetypes = { "arduino" },
				capabilities = {},
				cmd = {
					"arduino-language-server",
					"-cli-config",
					"/home/luca/.arduino15/arduino-cli.yaml",
					"-fqbn",
					"esp32:esp32:esp32",
					"-clangd",
					"/usr/bin/clangd",
					"-cli",
					"/usr/bin/arduino-cli",
				},
			})
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})
			lspconfig.cssls.setup({
				capabilities = capabilities,
			})
			lspconfig.hyprls.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.sqlls.setup({
				capabilities = capabilities,
				filetypes = { "sql", "mysql" },
				root_dir = function()
					return vim.loop.cwd()
				end,
			})
			lspconfig.taplo.setup({})

			-- Hyprlang LSP
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.hl", "hypr*.conf" },
				callback = function(event)
					print(string.format("starting hyprls for %s", vim.inspect(event)))
					vim.lsp.start({
						name = "hyprlang",
						cmd = { "hyprls" },
						root_dir = vim.fn.getcwd(),
					})
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "Lsp actions",
				callback = function()
					vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
					vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {})
					vim.keymap.set({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, {})
				end,
			})
		end,
	},
}
