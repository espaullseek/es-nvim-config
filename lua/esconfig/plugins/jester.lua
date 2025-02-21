return {
  "David-Kunz/jester",
  config = function()
    local jester = require("jester")

    jester.setup({
      dap = {
        type = "pwa-node",
      },
    })

    vim.keymap.set("n", "<Leader>jrr", jester.run, {})
    vim.keymap.set("n", "<Leader>jrf", jester.run_file, {})
    vim.keymap.set("n", "<Leader>jdr", jester.debug, {})
    vim.keymap.set("n", "<Leader>jdf", jester.debug_file, {})
  end,
}
