return {

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = function()
      require("indent_blankline").setup({
        indentLine_enabled = 0,
        filetype_exclude = {
          "help",
          "terminal",
          "lazy",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "nvdash",
          "nvcheatsheet",
          "",
        },
        buftype_exclude = { "terminal", "nofile" },
        show_first_indent_level = false,
        show_current_context = true,
        show_current_context_start = true,
        show_end_of_line = true,
        use_treesitter = true,
        show_current_context_start_on_current_line = false,
        char = "",
        -- char = "╎",
        -- context_char = "",
      })
      vim.cmd.hi("clear IndentBlanklineContextStart")
      vim.cmd.hi("link IndentBlanklineContextStart CursorLine")
    end,
    version = "2.20.7",
  },

  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
