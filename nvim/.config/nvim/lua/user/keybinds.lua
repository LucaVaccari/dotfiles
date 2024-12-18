-- Tab management
-- vim.keymap.set('n', '<C-t>', ':tabnew<CR>')
-- Disable arrows movement
vim.keymap.set({ "n", "x" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "x" }, "<Down>", "<Nop>")
vim.keymap.set({ "n", "x" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "x" }, "<Right>", "<Nop>")

-- Copy/Cut/Paste
vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Copy to system clipboard" }) -- copy to system clipboard ("+" register)
vim.keymap.set({ "n", "x" }, "gp", '"+p', { desc = "Paste to system clipboard" }) -- paste to system clipboard ("+" register)
vim.keymap.set({ "n", "x" }, "x", '"_x') -- delete char without adding it to register

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Tabs
vim.keymap.set({ "n", "t" }, "<C-w>|", "<cmd>vsplit<cr>", { desc = "Vertical tab split" })
vim.keymap.set({ "n", "t" }, "<C-w>-", "<cmd>split<cr>", { desc = "Horizontal tab split" })

vim.keymap.set("n", "<A-q>", "<cmd>q<cr>", { desc = "Quit" })
