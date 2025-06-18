require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "tsx",
    "typescript",
    "javascript",
    "html",
    "css",
    -- "java",
    -- "vue",
    -- "astro",
    -- "svelte",
    "gitcommit",
    -- "graphql",
    "json",
    "json5",
    "lua",
    "markdown",
    "markdown_inline",
    -- "prisma",
    "vim",
  }, -- one of "all", or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "haskell" }, -- list of parsers to ignore installing
  highlight = {
    enable = true,
    disable = { "markdown", "markdown_inline" }, -- Désactive le highlight pour le markdown
    additional_vim_regex_highlighting = false, -- Évite les conflits avec d'autres highlighters
  },
  autotag = {
    enable = true,
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "<leader>gnn",
      node_incremental = "<leader>gnr",
      scope_incremental = "<leader>gne",
      node_decremental = "<leader>gnt",
    },
  },

  indent = {
    enable = true,
  },

  textobjects = {
    move = {
      enable = false,
      set_jumps = false, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = "@function.outer",
        ["]m"] = "@class.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
        ["]M"] = "@class.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        ["[m"] = "@class.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        ["[M"] = "@class.outer",
      },
    },
    select = {
      enable = false,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = false,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = false,
      swap_next = {
        ["~"] = "@parameter.inner",
      },
    },
  },

  textsubjects = {
    enable = true,
    prev_selection = "<BS>",
    keymaps = {
      ["<CR>"] = "textsubjects-smart", -- works in visual mode
    },
  },
}
