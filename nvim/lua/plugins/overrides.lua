return {
  -- Override mini.move (LazyVim Extra)
  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        -- Move visual selection (Visual Mode)
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",

        -- Move current line (Normal Mode)
        -- doesn't work, but maybe VISUAL mode move is enough
        -- line_left = "<C-h>",
        -- line_right = "<C-l>",
        -- line_down = "<C-j>",
        -- line_up = "<C-k>",
      },
    },
  },
}
