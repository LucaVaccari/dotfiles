return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup()
			-- Tabline binds
			vim.keymap.set("n", "<C-q>", function()
				require("bufdelete").bufdelete(0, true)
			end) -- shift+Quit to close current tab
			vim.keymap.set("n", "g1", function()
				require("bufferline").go_to_buffer(1, true)
			end)
			vim.keymap.set("n", "g2", function()
				require("bufferline").go_to_buffer(2, true)
			end)
			vim.keymap.set("n", "g3", function()
				require("bufferline").go_to_buffer(3, true)
			end)
			vim.keymap.set("n", "g4", function()
				require("bufferline").go_to_buffer(4, true)
			end)
			vim.keymap.set("n", "g5", function()
				require("bufferline").go_to_buffer(5, true)
			end)
			vim.keymap.set("n", "g6", function()
				require("bufferline").go_to_buffer(6, true)
			end)
			vim.keymap.set("n", "g7", function()
				require("bufferline").go_to_buffer(7, true)
			end)
			vim.keymap.set("n", "g8", function()
				require("bufferline").go_to_buffer(8, true)
			end)
			vim.keymap.set("n", "g9", function()
				require("bufferline").go_to_buffer(9, true)
			end)
			vim.keymap.set("n", "g0", function()
				require("bufferline").go_to_buffer(10, true)
			end)
			vim.keymap.set("n", "<M-j>", "<cmd>BufferLineCyclePrev<CR>") -- Alt+j to move to left
			vim.keymap.set("n", "<M-k>", "<cmd>BufferLineCycleNext<CR>") -- Alt+k to move to right
			vim.keymap.set("n", "<M-J>", "<cmd>BufferLineMovePrev<CR>") -- Alt+Shift+j grab to with you to left
			vim.keymap.set("n", "<M-K>", "<cmd>BufferLineMoveNext<CR>") -- Alt+Shift+k grab to with you to right
		end,
	},
	{
		"famiu/bufdelete.nvim",
	},
}
