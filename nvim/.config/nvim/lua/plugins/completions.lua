return {
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "dmitmel/cmp-digraphs" },
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			vim.opt.completeopt = { "menu", "menuone" }

			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				enabled = function()
					-- disable completion in comments
					local context = require("cmp.config.context")
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.confirm({ select = true }),
					["<C-f>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-b>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						local col = vim.fn.col(".") - 1

						if cmp.visible() then
							cmp.select_next_item({})
						elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
							fallback()
						else
							cmp.complete()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({})
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", keyword_length = 1 },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
					{ name = "path" },
					{ name = "digraphs", keyword_length = 0 },
					{ name = "nvim_lua", keyword_length = 0 },
				}),
				formatting = {
					format = function(entry, vim_item)
						local kind_icons = {
							Text = "",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰇽",
							Variable = "󰂡",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "󰅲",
						}

						-- Kind icons
						vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) -- , vim_item.kind) -- This concatenates the icons with the name of the item kind
						local menu_icon = {
							nvim_lsp = "λ",
							luasnip = "⋗",
							buffer = "Ω",
							path = "🖫",
							digraphs = "dig",
							nvim_lua = "N",
						}

						vim_item.menu = menu_icon[entry.source.name]
						return vim_item
					end,
				},
			})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- diagnostic lines look
			local sign = function(opts)
				vim.fn.sign_define(opts.name, {
					texthl = opts.name,
					text = opts.text,
					numhl = "",
				})
			end

			sign({ name = "DiagnosticSignError", text = "✘" })
			sign({ name = "DiagnosticSignWarn", text = "▲" })
			sign({ name = "DiagnosticSignHint", text = "⚑" })
			sign({ name = "DiagnosticSignInfo", text = "»" })

			-- vim.diagnostic.config({
			-- 	virtual_text = true,
			-- 	signs = true,
			-- 	update_in_insert = true,
			-- 	underline = true,
			-- 	severity_sort = true,
			-- 	float = {
			-- 		border = "rounded",
			-- 		source = "always",
			-- 	},
			-- })
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
						return
					end
					require("lsp_signature").on_attach({
						-- ... setup options here ...
					}, bufnr)
				end,
			})
		end,
	},
}
