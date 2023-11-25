local keymap= vim.keymap

-- Dir Nav
keymap.set("n", "<leader>nf", ":NvimTreeFocus<CR>", {noremap = true, silent = true})
keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>", {noremap = true, silent = true})



-- Indentation
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")

-- Comments
vim.api.nvim_set_keymap("n","<C-_>","gcc", {noremap = false})
vim.api.nvim_set_keymap("v","<C-_>","gcc", {noremap = false})
