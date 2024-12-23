return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
		{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
		{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
		{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	},
	config = function()
		-- If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
		vim.g.tmux_navigator_preserve_zoom = 1
		vim.g.tmux_navigator_no_wrap = 1
	end,
}
