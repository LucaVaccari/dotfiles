return {
	"wfxr/minimap.vim",
	config = function()
		vim.api.nvim_create_autocmd({ "BufAdd", "VimEnter" }, {
			command = "Minimap",
		})
		vim.api.nvim_create_autocmd("ExitPre", {
			command = "MinimapClose",
		})
	end,
}
