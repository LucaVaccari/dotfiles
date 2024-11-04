-- Tab management
-- vim.keymap.set('n', '<C-t>', ':tabnew<CR>')

-- Copy/Cut/Paste
vim.keymap.set({'n', 'x'}, 'gy', '"+y') -- copy to system clipboard ("+" register)
vim.keymap.set({'n', 'x'}, 'gp', '"+p') -- paste to system clipboard ("+" register)
vim.keymap.set({'n', 'x'}, 'x', '"_x') -- delete char without adding it to register

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
