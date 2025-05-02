return {
{
  "kylechui/nvim-surround",
vscode=true,
  opts = {
    keymaps = {
      -- For example, override the normal mode mapping for the surround operator.
      -- Depending on the functionality you want to change, you might adjust:
      insert = "<C-g>z",
      insert_line = "<C-g>S",
      normal = "yz",
      normal_cur = "yzz",
    --   normal_line = "yS",
    --   normal_cur_line = "ySS",
    --   visual = "S",
    --   visual_line = "gS",
      delete = "dz",
      change = "cz",
      change_line = "cS",
  normal_cur = "z",       -- e.g., change "ys" to "z" for surrounding around the cursor.
      normal_line = "zz",     -- or assign another key for line-wise operations.
      -- You can similarly override other mappings like visual or operator-pending ones.
    },
  },
}
}