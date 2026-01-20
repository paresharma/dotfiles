return {
  -- The GOAT of Git plugins
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb", -- Enables :GBrowse for GitHub
    },
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "GBrowse" },
    -- keys = {
    --   { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
    --   { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
    -- },
  },

  -- Another classic: vim-surround (prefered it over nvim-surround)
  { "tpope/vim-surround" },
}
