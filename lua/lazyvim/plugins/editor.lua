return {

  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.grug_far({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    vscode = true,
    enabled = true,
    event = "VeryLazy",
    opts = {
      label = {
        style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
        rainbow = { enabled = true, shade = 9 },
      },
      modes = {
        search = {
          enabled = false,
        },
        char = {
          multi_line = false,
          jump_labels = true,
        },
      },
    },
      -- stylua: ignore
      keys = {
         { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end,              desc = "Flash" },
         { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
         { "r", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
         { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
         -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
  },
  {
    "samjwill/nvim-unception",
    event = "VeryLazy",
  },
  {
    "SR-Mystar/yazi.nvim",
    cmd = "Yazi",
    opts = {
      continue_use_it = true,
      size = {
        width = 0.9, -- maximally available columns
        height = 0.8, -- maximally available lines
      },
      border = "rounded",
    },
    keys = {
      {
        "<M-n>",
        function()
          vim.cmd("Yazi")
        end,
        { noremap = true, silent = true },
        desc = "Open the file manager",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      on_open = function(win)
        vim.cmd.hi("clear ZenBg")
        local view = require("zen-mode.view")
        local layout = view.layout(view.opts)
        vim.api.nvim_win_set_config(win, {
          width = layout.width,
          height = layout.height - 1,
        })
        vim.api.nvim_win_set_config(view.bg_win, {
          width = vim.o.columns,
          height = view.height() - 1,
          row = 1,
          col = layout.col,
          relative = "editor",
        })
      end,
      window = {
        width = 130, -- width of the Zen window
        height = 1, -- height of the Zen window
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = true, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 3, -- turn off the statusline in zen mode
        },
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        tmux = { enabled = true }, -- disables the tmux statusline
        wezterm = {
          enabled = false,
          -- can be either an absolute font size or the number of incremental steps
          font = "+4", -- (10% increase per step)
        },
      },
      -- callback where you can add custom code when the Zen window opens
    },
  },
  { "IndianBoy42/vim-visual-multi", event = "VeryLazy" },
  {
    "backdround/global-note.nvim",
    event = "VeryLazy",
    config = function()
      local global_note = require("global-note")
      local get_project_name = function()
        ---@diagnostic disable-next-line: undefined-field
        local project_directory, err = vim.uv.cwd()
        if project_directory == nil then
          vim.notify(err, vim.log.levels.WARN)
          return nil
        end

        local project_name = vim.fs.basename(project_directory)
        if project_name == nil then
          vim.notify("Unable to get the project name", vim.log.levels.WARN)
          return nil
        end

        return project_name
      end
      global_note.setup({
        additional_presets = {
          project_local = {
            command_name = "ProjectNote",

            filename = function()
              return get_project_name() .. ".md"
            end,

            title = "Project note",
          },
        },
      })

      vim.keymap.set("n", "<leader>n", function()
        global_note.toggle_note("project_local")
      end, {
        desc = "todo, Toggle project note",
      })
    end,
  },
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        vim.opt.signcolumn = "yes"
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      -- { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      -- { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
      -- { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      -- { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
  {
    "echasnovski/mini.hipatterns",
    version = "*",
    event = "VeryLazy",
    config = function()
      -- vim.cmd.hi("clear Todo")
      require("mini.hipatterns").setup()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE', 'DONE':
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          done = { pattern = "%f[%w]()DONE()%f[%W]", group = "Special" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>x",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>X",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
  {
    import = "lazyvim.plugins.extras.editor.fzf",
    enabled = function()
      return LazyVimx.pick.want() == "fzf"
    end,
  },
  {
    import = "lazyvim.plugins.extras.editor.telescope",
    enabled = function()
      return LazyVimx.pick.want() == "telescope"
    end,
  },
}
