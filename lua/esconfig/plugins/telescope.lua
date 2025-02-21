return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      local function find_files()
        builtin.find_files({
          previewer = false,
          hidden = true,
          file_ignore_patterns = { "node_modules", "dist", "build", "target" },
        })
      end

      local function find_git_files()
        builtin.git_files({
          previewer = false,
          show_untracked = true,
        })
      end

      local function list_buffers()
        builtin.buffers({
          sort_lastused = true,
          previewer = false,
          initial_mode = "normal",
          ignore_current_buffer = true,
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
          end)
        end,
      })

      local function filenameFirst(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        end
        return string.format("%s\t\t%s", tail, parent)
      end

      vim.keymap.set("n", "<leader>pf", find_files, {})
      vim.keymap.set("n", "<C-p>", find_git_files, {})
      vim.keymap.set("n", "<C-b>", list_buffers, {})

      -- fuzzy file finding
      vim.keymap.set("n", "<leader>ps", function()
        builtin.grep_string({
          search = vim.fn.input("Grep > "),
        })
      end)

      -- live grep
      vim.keymap.set("n", "<leader>pg", function()
        builtin.live_grep()
      end)

      -- file browser extension
      local fb_actions = telescope.extensions.file_browser.actions
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup({
        pickers = {
          find_files = {
            path_display = filenameFirst,
          },
          lsp_references = {
            path_display = filenameFirst,
            show_line = false,
          },
          live_grep = {
            path_display = filenameFirst,
            show_line = false,
          },
        },
        extensions = {
          file_browser = {
            initial_mode = "normal",
            sorting_strategy = "ascending",
            -- disables netrw and use telescope-file-browser in its place
            -- hijack_netrw = true, // disabled since nvim-tree is used
            mappings = {
              ["i"] = {},
              ["n"] = {
                -- backspace for going up one dir
                ["-"] = fb_actions.goto_parent_dir,
              },
            },
          },
          live_grep_args = {
            path_display = filenameFirst,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " -g " }),
                ["<C-l>"] = lga_actions.quote_prompt({ postfix = " -tts -g '!*.test.*'" }),
              },
            },
          },
        },
      })

      telescope.load_extension("file_browser")
      telescope.load_extension("live_grep_args")

      vim.api.nvim_set_keymap("n", "<leader><leader>n", ":Telescope file_browser<CR>", { noremap = true })

      vim.keymap.set(
        "n",
        "<leader>lga",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
      )

      -- open file_browser with the path of the current buffer
      vim.api.nvim_set_keymap(
        "n",
        "<leader><C-e>",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { noremap = true }
      )
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
