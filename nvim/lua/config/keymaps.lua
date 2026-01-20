-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "ZZ", function()
  vim.cmd("update") -- Only writes if the buffer was modified
  Snacks.bufdelete()
end, { desc = "Save and Delete Buffer" })

vim.keymap.set("n", "<leader>zz", function()
  Snacks.picker.grep({
    search = vim.fn.expand("<cword>"),
    desc = "Grep Word (Root Dir)",
  })
end, { desc = "Search word under cursor in project" })
