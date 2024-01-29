local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Append file to Harpoon" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>hq", function() harpoon:list():select(1) end, { desc = "Quick Harpoon 1" })
vim.keymap.set("n", "<leader>hw", function() harpoon:list():select(2) end, { desc = "Quick Harpoon 2" })
vim.keymap.set("n", "<leader>he", function() harpoon:list():select(3) end, { desc = "Quick Harpoon 3" })
vim.keymap.set("n", "<leader>hr", function() harpoon:list():select(4) end, { desc = "Quick Harpoon 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
