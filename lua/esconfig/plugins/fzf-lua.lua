return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    vim.keymap.set("n", "<leader>lgg", fzf.live_grep_glob, { desc = "Live grep with args" })

    fzf.setup({
      grep = {
        actions = {
          ["ctrl-q"] = {
            fn = fzf.actions.file_edit_or_qf,
            prefix = "select-all+",
          },
        },
      },
      winopts = {
        preview = { default = "bat_native" },
      },
      files = {
        git_icons = false,
        file_icons = false,
      },
    })
  end,
}
