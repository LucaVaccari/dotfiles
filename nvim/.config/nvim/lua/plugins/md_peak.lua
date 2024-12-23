return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup({
			auto_load = true,
			close_on_bdelete = true,
			syntax = true,
			theme = "dark",
			update_on_change = true,
			filetype = { "markdown" },
			throttle_at = 200000,
			throttle_time = "auto",
			app = "webview",
		})
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})

		-- Open markdown preview
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = "*.md",
			command = "PeekOpen",
		})
	end,
}
