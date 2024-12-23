return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				pickers = {
					buffers = { initial_mode = "normal" },
					diagnostics = { initial_mode = "normal" },
					lsp_definitions = { initial_mode = "normal" },
					lsp_type_definitions = { initial_mode = "normal" },
					lsp_implementations = { initial_mode = "normal" },
					lsp_references = { initial_mode = "normal" },
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>:", builtin.commands, { desc = "Telescope commands" })
			vim.keymap.set("n", "<A-d>", builtin.diagnostics, { desc = "List diagnostics" })

			-- LSP mappings
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "Lsp actions",
				callback = function()
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
					vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "LSP go to definition" })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
					vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "LSP go to type definition" })
					vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "LSP go to implementation" })
					vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "LSP references for word under cursor" })
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP rename" })
					vim.keymap.set({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, { desc = "LSP code actions" })
				end,
			})
			-- TODO test
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope cwd=.<cr>", { desc = "Show todos in cwd" })
		end,
	},
}
