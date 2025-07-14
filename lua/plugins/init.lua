---@diagnostic disable: missing-fields
local overrides = require "configs.overrides"
local cmp_opt = require "configs.cmp"

return {
  --------------------------- AI plugins ---------------------------
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- set this if you want to always pull the latest change
    keys = {
      {
        "<leader>a+",
        function()
          local tree_ext = require "avante.extensions.nvim_tree"
          tree_ext.add_file()
        end,
        desc = "Select file in NvimTree",
        ft = "NvimTree",
      },
      {
        "<leader>a-",
        function()
          local tree_ext = require "avante.extensions.nvim_tree"
          tree_ext.remove_file()
        end,
        desc = "Deselect file in NvimTree",
        ft = "NvimTree",
      },
    },
    opts = {
      provider = "kimi",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
          extra_request_body = {
            max_tokens = 8192,
          },
        },
        kimi = {
          __inherited_from = "openai",
          api_key_name = "KIMI_API_KEY",
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
        },
      },
      selector = {
        exclude_auto_select = { "NvimTree" },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = false,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "piersolenski/wtf.nvim",
    commit = "7e6a73f",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    config = function()
      require("wtf").setup {
        popup_type = "popup",
        provider = "deepseek",
        openai_api_key = "$DEEPSEEK_API_KEY",
        openai_model_id = "deepseek-coder",
        openai_base_url = "https://api.deepseek.com",
      }
    end,
  },
  -------------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = overrides.mason,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "artemave/workspace-diagnostics.nvim",
      "jubnzv/virtual-types.nvim",
      {
        "mason-org/mason.nvim",
        dependencies = {
          "mason-org/mason-lspconfig.nvim",
        },
        opts = overrides.mason,
        config = function(_, opts)
          require("mason").setup(opts)
          local mr = require "mason-registry"
          mr:on("package:install:success", function()
            vim.defer_fn(function()
              require("lazy.core.handler.event").trigger {
                event = "FileType",
                buf = vim.api.nvim_get_current_buf(),
              }
            end, 100)
          end)
          require "configs.lspconfig"
        end,
      },
    },
    config = function() end,
  },
  {
    "folke/which-key.nvim",
    enabled = true,
  },
  {
    "nvchad/volt",
    event = "BufReadPost",
    dependencies = {
      "nvzone/minty",
      "nvzone/menu",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      require "nvchad.configs.gitsigns"
    end,
    config = function(_, opts)
      require("scrollbar.handlers.gitsigns").setup()
      require("gitsigns").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = {
      "rachartier/tiny-devicons-auto-colors.nvim",
    },
    opts = overrides.devicons,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "debugloop/telescope-undo.nvim",
      "gnfisher/nvim-telescope-ctags-plus",
      "FabianWirth/search.nvim",
      "Marskey/telescope-sg",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      require("telescope").load_extension "luasnip"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "filNaj/tree-setter",
      "RRethy/nvim-treesitter-textsubjects",
      "danymat/neogen",
    },
    -- opts = overrides.treesitter,
    build = ":TSUpdate",
    init = function(plugin)
      -- perf: make treesitter queries available at startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    config = function()
      require "configs.treesitter"
    end,
  },
  -- {
  --   "doxnit/cmp-luasnip-choice",
  --   event = "InsertEnter",
  --   opts = { auto_open = true },
  -- },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "antosha417/nvim-lsp-file-operations" },
    opts = require "configs.tree",
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      require("nvim-tree.diagnostics").update_lsp()
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    opt = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "configs.oil"
    end,
  },
  { "mbbill/undotree", lazy = false, cmd = "UndotreeToggle" },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "CursorHold", "CursorMoved" },
    opts = {
      render = "virtual",
      virtual_symbol = "",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = cmp_opt.cmp,
    dependencies = {
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      -- "hrsh7th/cmp-copilot",
      -- "ray-x/cmp-treesitter",
      -- "tzachar/cmp-fuzzy-buffer",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "tzachar/fuzzy.nvim",
      "js-everts/cmp-tailwind-colors",
      "rafamadriz/friendly-snippets",
      {
        "noisethanks/supermaven-nvim",
        branch = "single_line_preview_options",
        config = function()
          require("supermaven-nvim").setup {
            single_line_suggestion_newline = true,
            show_diff_only = true,
            keymaps = {
              accept_suggestion = "<C-a>",
              clear_suggestion = "<C-c>",
            },
            color = {
              suggestion_color = "#03a598",
              cterm = 117,
            },
          }
          require("supermaven-nvim.completion_preview").suggestion_group = "SupermavenSuggestion"
        end,
      },
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
          ---@diagnostic disable-next-line: different-requires
          require "configs.luasnip"
        end,
      },
      {
        "windwp/nvim-autopairs",
        config = function()
          require "configs.autopair"
        end,
      },
      -- {
      --   "zbirenbaum/copilot.lua",
      --   event = "InsertEnter",
      --   dependencies = {
      --     {
      --       "zbirenbaum/copilot-cmp",
      --       config = function()
      --         require("copilot_cmp").setup()
      --       end,
      --     },
      --   },
      --   config = function()
      --     require("copilot").setup {
      --       suggestion = {
      --         enabled = false,
      --         auto_trigger = false,
      --         keymap = {
      --           accept_word = false,
      --           accept_line = false,
      --         },
      --       },
      --       panel = {
      --         enabled = false,
      --       },
      --       filetypes = {
      --         gitcommit = false,
      --         TelescopePrompt = false,
      --       },
      --       server_opts_overrides = {
      --         trace = "verbose",
      --         settings = {
      --           advanced = {
      --             listCount = 3,
      --             inlineSuggestCount = 3,
      --           },
      --         },
      --       },
      --     }
      --   end,
      -- },
    },
    config = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item.kind = "⬤"
          format_kinds(entry, item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, item)
        end
        return format_kinds(entry, item)
      end
      ---@diagnostic disable-next-line: different-requires
      local cmp = require "cmp"

      cmp.setup(opts)

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = opts.mapping,
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function()
      require("neoscroll").setup {
        mappings = {
          "<C-u>",
          "<C-d>",
        },
      }
    end,
  },
  ----------------------------------------- enhance plugins ------------------------------------------
  {
    "chrisgrieser/nvim-puppeteer",
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      char = {
        keys = {},
      },
      modes = {
        char = {
          highlight = {
            backdrop = false,
          },
        },
      },
    },
    keys = {
      {
        "<leader>z",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump {
            highlight = {
              backdrop = false,
              matches = true,
              priority = 5000,
              groups = {
                match = "FlashMatch",
                label = "DiagnosticHint",
                current = "FlashCurrent",
              },
            },
            label = {
              before = true,
              after = false,
            },
          }
        end,
        desc = "Flash",
      },
      {
        "Z",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter {
            label = {
              before = true,
              after = false,
              rainbow = { enabled = true },
            },
          }
        end,
        desc = "Flash Treesitter",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search {
            highlight = {
              backdrop = false,
              matches = true,
              priority = 5000,
              groups = {
                match = "FlashMatch",
                label = "DiagnosticHint",
                current = "FlashCurrent",
              },
            },
            label = {
              before = true,
              after = false,
            },
          }
        end,
        desc = "Treesitter Search",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote {
            highlight = {
              backdrop = false,
              matches = true,
              priority = 5000,
              groups = {
                match = "FlashMatch",
                label = "DiagnosticHint",
                current = "FlashCurrent",
              },
            },
            label = {
              before = true,
              after = false,
            },
          }
        end,
        desc = "Remote Flash",
      },
    },
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    config = function()
      require "configs.autosave"
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "CursorHold",
    config = function()
      require("illuminate").configure {
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        under_cursor = false,
      }
    end,
  },
  {
    "andrewferrier/debugprint.nvim",
    lazy = false,
    opts = {
      keymaps = {
        visual = {
          variable_below = "<leader><leader>d",
        },
        normal = {
          variable_below = "<leader><leader>d",
        },
      },
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    config = function()
      require("actions-preview").setup {
        diff = {
          algorithm = "patience",
          ignore_whitespace = true,
        },
        telescope = require("telescope.themes").get_dropdown { winblend = 10 },
      }
    end,
  },
  -- {
  --   "hiphish/rainbow-delimiters.nvim",
  --   event = "BufReadPost",
  --   config = function()
  --     local rainbow_delimiters = require "rainbow-delimiters"
  --
  --     vim.g.rainbow_delimiters = {
  --       strategy = {
  --         [""] = rainbow_delimiters.strategy["global"],
  --         vim = rainbow_delimiters.strategy["local"],
  --       },
  --       query = {
  --         [""] = "rainbow-delimiters",
  --         lua = "rainbow-blocks",
  --       },
  --       highlight = {
  --         "RainbowDelimiterRed",
  --         "RainbowDelimiterYellow",
  --         "RainbowDelimiterBlue",
  --         "RainbowDelimiterOrange",
  --         "RainbowDelimiterGreen",
  --         "RainbowDelimiterViolet",
  --         "RainbowDelimiterCyan",
  --       },
  --     }
  --   end,
  -- },
  {
    "gbprod/cutlass.nvim",
    event = "BufEnter",
    opts = {
      cut_key = "x",
      override_del = true,
      exclude = {},
      registers = {
        select = "_",
        delete = "_",
        change = "_",
      },
    },
  },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.cmd [[
      let g:VM_mouse_mappings = 1
      let g:VM_default_mappings = 0
      let g:VM_leader = ','
      let g:VM_maps = {}
      let g:VM_maps['Find Under']         = '<C-n>'
      let g:VM_maps['Find Subword Under'] = '<C-n>'
      let g:VM_maps["Select Cursor Up"]   = '<M-C-Up>'
      let g:VM_maps["Select Cursor Down"] = '<M-C-Down>'
      let g:VM_maps["Undo"] = 'u'
      let g:VM_maps["Redo"] = '<C-r>'
      let g:VM_maps["Add Cursor Down"]             = '<C-M-j>'
      let g:VM_maps["Add Cursor Up"]               = '<C-M-k>'
      let g:VM_maps["Add Cursor At Pos"]           = '<C-c>'
      let g:VM_maps["Surround"]                    = 'S'
      let g:VM_maps["Mouse Cursor"]                = '<C-LeftMouse>'
      let g:VM_maps["Mouse Word"]                  = '<C-RightMouse>'
      let g:VM_maps["Mouse Column"]                = '<M-C-RightMouse>'
      let g:VM_maps["Switch Mode"]                 = ''

      let g:VM_maps["Find Next"]                   = ''
      let g:VM_maps["Find Prev"]                   = ''
      let g:VM_maps["Goto Next"]                   = ''
      let g:VM_maps["Goto Prev"]                   = ''
      let g:VM_maps["Seek Next"]                   = ''
      let g:VM_maps["Seek Prev"]                   = ''
      let g:VM_maps["Skip Region"]                 = ''
      let g:VM_maps["Remove Region"]               = 'q'
      let g:VM_maps["Invert Direction"]            = ''
      let g:VM_maps["Find Operator"]               = ""
      let g:VM_maps["Surround"]                    = ''
      let g:VM_maps["Replace Pattern"]             = ''

      let g:VM_maps["Tools Menu"]                  = ''
      let g:VM_maps["Show Registers"]              = ''
      let g:VM_maps["Case Setting"]                = ''
      let g:VM_maps["Toggle Whole Word"]           = ''
      let g:VM_maps["Transpose"]                   = ''
      let g:VM_maps["Align"]                       = ''
      let g:VM_maps["Duplicate"]                   = ''
      let g:VM_maps["Rewrite Last Search"]         = ''
      let g:VM_maps["Merge Regions"]               = ''
      let g:VM_maps["Split Regions"]               = ''
      let g:VM_maps["Remove Last Region"]          = 'Q'
      let g:VM_maps["Visual Subtract"]             = ''
      let g:VM_maps["Case Conversion Menu"]        = ''
      let g:VM_maps["Search Menu"]                 = ''

      let g:VM_maps["Run Normal"]                  = ''
      let g:VM_maps["Run Last Normal"]             = ''
      let g:VM_maps["Run Visual"]                  = ''
      let g:VM_maps["Run Last Visual"]             = ''
      let g:VM_maps["Run Ex"]                      = ''
      let g:VM_maps["Run Last Ex"]                 = ''
      let g:VM_maps["Run Macro"]                   = ''
      let g:VM_maps["Align Char"]                  = ''
      let g:VM_maps["Align Regex"]                 = ''
      let g:VM_maps["Numbers"]                     = ''
      let g:VM_maps["Numbers Append"]              = ''
      let g:VM_maps["Zero Numbers"]                = ''
      let g:VM_maps["Zero Numbers Append"]         = ''
      let g:VM_maps["Shrink"]                      = ""
      let g:VM_maps["Enlarge"]                     = ""

      let g:VM_maps["Toggle Block"]                = ''
      let g:VM_maps["Toggle Single Region"]        = ''
      let g:VM_maps["Toggle Multiline"]            = ''
    ]]
    end,
  },
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    config = function()
      require("auto-session").setup {
        enabled = true,
        auto_save = true,
        auto_restore = false,
        use_git_branch = true,
      }
    end,
  },
  -- {
  --   "obsidian-nvim/obsidian.nvim",
  --   lazy = true,
  --   ft = "markdown",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MeanderingProgrammer/render-markdown.nvim",
  --     opts = {
  --       heading = {
  --         sign = false,
  --         icons = { " ", " ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
  --         width = 79,
  --       },
  --       code = {
  --         sign = false,
  --         width = "block", -- use 'language' if colorcolumn is important for you.
  --         right_pad = 1,
  --       },
  --       dash = {
  --         width = 79,
  --       },
  --       pipe_table = {
  --         style = "full", -- use 'normal' if colorcolumn is important for you.
  --       },
  --     },
  --   },
  --   config = function()
  --     require("obsidian").setup {
  --       workspaces = {
  --         {
  --           name = "personal",
  --           path = "~/Documents/personal",
  --         },
  --         {
  --           name = "work",
  --           path = "~/Documents/work",
  --         },
  --       },
  --       disable_frontmatter = true,
  --       completion = {
  --         nvim_cmp = true,
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   "jonahgoldwastaken/copilot-status.nvim",
  --   event = "LspAttach",
  --   config = function()
  --     require("copilot_status").setup {
  --       icons = {
  --         idle = " ",
  --         error = " ",
  --         offline = " ",
  --         warning = " ",
  --         loading = " ",
  --       },
  --       debug = false,
  --     }
  --   end,
  -- },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {},
  },
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    opts = {
      hl_priority = 200,
      extras = { named_parameters = true },
    },
  },
  -- {
  --   "tzachar/local-highlight.nvim",
  --   event = { "CursorHold", "CursorHoldI" },
  --   dependencies = { "folke/snacks.nvim" },
  --   opts = {
  --     hlgroup = "Visual",
  --   },
  -- },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = { enabled = false },
    },
  },
  -- {
  --   "smoka7/hop.nvim",
  --   cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine", "HopNodes" },
  --   config = function()
  --     require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
  --   end,
  -- },
  {
    "nguyenvukhang/nvim-toggler",
    event = "BufReadPost",
    config = function()
      require("nvim-toggler").setup {
        remove_default_keybinds = true,
      }
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    init = function()
      require("mini.surround").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    version = "*",
    init = function()
      require("mini.ai").setup()
    end,
  },
  -- {
  --   "mawkler/modicator.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     -- These are required for Modicator to work
  --     vim.o.cursorline = true
  --     vim.o.number = true
  --     -- vim.o.termguicolors = true
  --   end,
  --   opts = {
  --     show_warnings = false,
  --     highlights = {
  --       defaults = { bold = true },
  --     },
  --   },
  -- },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("marks").setup {
        default_mappings = false,
        mappings = {
          set = "<leader>ma",
          next = "<leader>mn",
          prev = "<leader>mp",
          delete_buf = "<leader>mdb",
          delete_line = "<leader>mdl",
        },
      }
    end,
  },
  {
    "mvllow/modes.nvim",
    tag = "v0.3.0",
    event = "VeryLazy",
    config = function()
      require("modes").setup {
        colors = {
          bg = "", -- Optional bg param, defaults to Normal hl group
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#78ccc5",
          visual = "#9745be",
        },
        -- Set opacity for cursorline and number background
        line_opacity = {
          visual = 0.5,
          copy = 0.3,
          delete = 0.5,
          insert = 0.25,
        },

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore = { "NvimTree", "TelescopePrompt" },
      }
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    config = function()
      local map = vim.keymap.set

      require("grug-far").setup {}

      local is_grugfar_open = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if buf_name and buf_name == "grug-far" then
            return true
          end
        end
        return false
      end

      local toggle_grugfar = function()
        local open = is_grugfar_open()
        if open then
          require "grug-far/actions/close"()
        else
          vim.cmd "GrugFar"
        end
      end

      map("n", "<leader>²leader>gr", function()
        toggle_grugfar()
      end, { desc = "Toggle GrugFar" })
    end,
  },
  -- {
  --   "yorickpeterse/nvim-dd",
  --   event = "LspAttach",
  --   opts = {
  --     timeout = 1000,
  --   },
  -- },
  -- {
  --   "zeioth/garbage-day.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     notifications = false,
  --   },
  -- },
  {
    "0oAstro/dim.lua",
    event = "LspAttach",
    config = function()
      require("dim").setup {}
    end,
  },
  {
    "Wansmer/treesj",
    cmd = "TSJToggle",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    opts = {},
    init = function()
      require("yanky").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
      require("telescope").load_extension "yank_history"
    end,
  },
  ----------------------------------------- ui plugins ------------------------------------------
  {
    "gnikolaos/nx.nvim",
    branch = "fix/read-configs",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },

    opts = {
      -- See below for config options
      nx_cmd_root = "nx",
    },

    -- Plugin will load when you use these keys
    keys = {
      { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
    },
  },
  {
    "hedyhli/outline.nvim",
    event = "VeryLazy",
    config = function()
      require("outline").setup {}
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- opts = {
    --   position = "center",
    --   wrap = "overflow",
    -- },
    init = function()
      require "configs.alpha"
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          top_down = false,
        },
        init = function()
          local banned_messages = {
            "No information available",
            "Content is not an image.",
          }
          vim.notify = function(msg, ...)
            for _, banned in ipairs(banned_messages) do
              if msg:find(banned, 1, true) then
                return
              end
            end
            return require "notify"(msg, ...)
          end
        end,
      },
    },

    config = function()
      require "configs.noice"
      ---@diagnostic disable-next-line: different-requires
      vim.lsp.handlers["textDocument/hover"] = require("noice").hover
      ---@diagnostic disable-next-line: different-requires
      vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "WinScrolled",
    config = function()
      require "configs.scrollbar"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = function()
      require "configs.todo"
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
    cmd = "Trouble",
    config = function()
      require("trouble").setup {
        modes = {
          project_diagnostics = {
            mode = "diagnostics",
            filter = {
              any = {
                {
                  function(item)
                    return item.filename:find(vim.fn.getcwd(), 1, true)
                  end,
                },
              },
            },
          },
          mydiags = {
            mode = "diagnostics",
            filter = {
              any = {
                buf = 0,
                {
                  severity = vim.diagnostic.severity.ERROR,
                  function(item)
                    return item.filename:find(true, 1, (vim.loop or vim.uv).cwd())
                  end,
                },
              },
            },
          },
        },
        auto_close = true,
      }
    end,
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json", "yaml", "yml" },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "echasnovski/mini.animate",
    lazy = false,
    config = function()
      local animate = require "mini.animate"
      animate.setup {
        cursor = { timing = animate.gen_timing.linear { duration = 100, unit = "total" } },
        scroll = { enable = false },
        open = { enable = false },
        close = { enable = false },
        resize = { enable = false },
      }
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = "BufReadPost",
    config = function()
      require "configs.hlchunk"
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
  },
  {
    "BrunoKrugel/lazydocker.nvim",
    cmd = "LazyDocker",
  },
  {
    "BrunoKrugel/muren.nvim",
    cmd = "MurenToggle",
    config = true,
  },
  {
    "f-person/git-blame.nvim",
    lazy = false,
    cmd = "GitBlameToggle",
    config = function()
      require("gitblame").setup {
        --Note how the `gitblame_` prefix is omitted in `setup`
        enabled = false,
      }
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup {}
    end,
    opts = {
      blame_options = { "-w" },
    },
  },
  -- {
  --   "akinsho/git-conflict.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("git-conflict").setup {
  --       default_mappings = true, -- disable buffer local mapping created by this plugin
  --       default_commands = true, -- disable commands created by this plugin
  --       disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  --       list_opener = "copen", -- command or function to open the conflicts list
  --       highlights = { -- They must have background color, otherwise the default color will be used
  --         incoming = "DiffAdd",
  --         current = "DiffText",
  --       },
  --     }
  --   end,
  -- },
  { "rhysd/conflict-marker.vim", event = "VeryLazy" },
  -- {
  --   "kevinhwang91/nvim-fundo",
  --   event = "BufReadPost",
  --   opts = {},
  --   build = function()
  --     require("fundo").install()
  --   end,
  -- },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      require "configs.statuscol"
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require "configs.ufo"
    end,
  },
  -- {
  --   "chikko80/error-lens.nvim",
  --   event = "LspAttach",
  --   opts = {},
  -- },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = false,
          },
        },
        hooks = {
          diff_buf_win_enter = function(_, _, ctx)
            if ctx.layout_name:match "^diff2" then
              if ctx.symbol == "a" then
                vim.opt_local.winhl = table.concat({
                  "DiffAdd:DiffviewDiffAddAsDelete",
                  "DiffDelete:DiffviewDiffDelete",
                }, ",")
              elseif ctx.symbol == "b" then
                vim.opt_local.winhl = table.concat({
                  "DiffDelete:DiffviewDiffDelete",
                }, ",")
              end
            end
          end,
        },
      }
    end,
  },
  -- {
  --   "utilyre/sentiment.nvim",
  --   event = "LspAttach",
  --   opts = {},
  --   init = function()
  --     vim.g.loaded_matchparen = 1
  --   end,
  -- },
  {
    "0xAdk/full_visual_line.nvim",
    keys = { "V" },
    config = function()
      require("full_visual_line").setup {}
    end,
  },
  {
    "FeiyouG/command_center.nvim",
    cmd = "Commandcenter",
    config = function()
      require "configs.command"
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("hlslens").setup {
        build_position_cb = function(plist, _, _, _)
          require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end,
      }

      vim.cmd [[
          augroup scrollbar_search_hide
              autocmd!
              autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
          augroup END
      ]]
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPost",
    opts = {},
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup {
        init = function()
          require "hover.providers.lsp"
          -- require "hover.providers.diagnostic"
          require "hover.providers.fold_preview"
          require "hover.providers.gh"
        end,
        preview_opts = {
          border = "rounded",
        },
        preview_window = true,
        title = true,
        -- mouse_providers = {
        --   "LSP",
        -- },
        -- mouse_delay = 1000,
      }
    end,
  },
  -- {
  --   "Wansmer/symbol-usage.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require "configs.symbol"
  --   end,
  -- },
  {
    "folke/edgy.nvim",
    event = "BufReadPost",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      fix_win_height = vim.fn.has "nvim-0.11.0" == 0,
      bottom = {
        {
          ft = "toggleterm",
          size = { height = 0.1 },
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
        { ft = "qf", title = "QuickFix" },
        "Trouble",
        "Noice",
        {
          ft = "NoiceHistory",
          title = " Log",
          open = function()
            ---@diagnostic disable-next-line: different-requires
            require("noice").cmd "history"
          end,
        },
        -- {
        --   ft = "neotest-output-panel",
        --   title = " Test Output",
        --   open = function()
        --     vim.cmd.vsplit()
        --     require("neotest").output_panel.toggle()
        --   end,
        -- },
        {
          ft = "DiffviewFileHistory",
          title = " Diffs",
        },
        -- {
        --   ft = "grug-far",
        --   title = "Replace",
        --   size = { width = 0.2 },
        -- },
      },
      left = {
        { ft = "undotree", title = "Undo Tree" },
        {
          ft = "diff",
          title = " Diffs",
        },

        {
          ft = "DiffviewFileHistory",
          title = " Diffs",
        },
        {
          ft = "DiffviewFiles",
          title = " Diffs",
        },
        -- {
        --   ft = "neotest-summary",
        --   title = "  Tests",
        --   open = function()
        --     require("neotest").summary.toggle()
        --   end,
        -- },
      },
      right = {
        "sagaoutline",
        "neotest-output-panel",
        "neotest-summary",
      },
      options = {
        left = { size = 40 },
        bottom = { size = 10 },
        right = { size = 30 },
        top = { size = 10 },
      },
      wo = {
        winbar = true,
        signcolumn = "no",
      },
    },
  },
  -- {
  --   "akinsho/toggleterm.nvim",
  --   -- keys = { [[<C-\>]] },
  --   cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
  --   opts = {
  --     size = function(term)
  --       if term.direction == "horizontal" then
  --         return 0.25 * vim.api.nvim_win_get_height(0)
  --       elseif term.direction == "vertical" then
  --         return 0.25 * vim.api.nvim_win_get_width(0)
  --       elseif term.direction == "float" then
  --         return 85
  --       end
  --     end,
  --     open_mapping = [[<C-\>]],
  --     hide_numbers = true,
  --     shade_terminals = false,
  --     insert_mappings = true,
  --     start_in_insert = true,
  --     persist_size = true,
  --     direction = "horizontal",
  --     close_on_exit = true,
  --     shell = vim.o.shell,
  --     autochdir = true,
  --     highlights = {
  --       NormalFloat = {
  --         link = "Normal",
  --       },
  --       FloatBorder = {
  --         link = "FloatBorder",
  --       },
  --     },
  --     float_opts = {
  --       border = "rounded",
  --       winblend = 0,
  --     },
  --   },
  -- },
  {
    "utilyre/barbecue.nvim",
    event = "BufWinEnter",
    dependencies = { "SmiteshP/nvim-navic" },
    opts = {},
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    config = function()
      require "configs.glance"
    end,
    keys = {
      { "gd", "<cmd>Glance definitions<CR>", desc = "LSP Definition" },
      { "gr", "<cmd>Glance references<CR>", desc = "LSP References" },
      { "gm", "<cmd>Glance implementations<CR>", desc = "LSP Implementations" },
      { "gy", "<cmd>Glance type_definitions<CR>", desc = "LSP Type Definitions" },
    },
  },
  ----------------------------------------- language plugins ------------------------------------------
  {
    "code-biscuits/nvim-biscuits",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-biscuits").setup {
        cursor_line_only = true,
        show_on_start = true,
        default_config = {
          prefix_string = " 📎 ",
        },
      }
    end,
  },
  {
    "davidmh/cspell.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "Joakker/lua-json5" },
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local cspell = require "cspell"
      local ok, none_ls = pcall(require, "null-ls")
      if not ok then
        return
      end
      local config = {
        cspell_config_dirs = {
          vim.fn.stdpath "config" .. "/cspell",
        },
      }

      local b = none_ls.builtins

      local sources = {
        -- cspell
        cspell.diagnostics.with {
          -- Set the severity to HINT for unknown words
          config = config,

          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["HINT"]
          end,
        },
        cspell.code_actions.with { config = config },
      }
      -- Define the debounce value
      local debounce_value = 5000
      return {
        sources = sources,
        debounce = debounce_value,
        debug = false,
        on_event = { "InsertLeave" },
      }
    end,
  },
  {
    "yioneko/nvim-vtsls",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
  },

  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   ft = {
  --     "javascript",
  --     "typescript",
  --     "javascriptreact",
  --     "typescriptreact",
  --   },
  --   config = function()
  --     require "configs.ts"
  --   end,
  -- },

  -- {
  --   "hinell/lsp-timeout.nvim",
  --   dependencies = { "neovim/nvim-lspconfig" },
  -- },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
  },
  -- {
  --   "nvim-java/nvim-java",
  --   config = function()
  --     require("java").setup()
  --     require("lspconfig").jdtls.setup {}
  --   end,
  -- },
  -- {
  {
    "BrunoKrugel/package-info.nvim",
    event = "BufEnter package.json",
    opts = {
      icons = {
        enable = true,
        style = {
          up_to_date = "  ",
          outdated = "  ",
        },
      },
      autostart = true,
      hide_up_to_date = true,
      hide_unstable_versions = true,
    },
  },
  -- {
  --   "nvim-neotest/neotest",
  --   ft = { "go", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  --   dependencies = {
  --     "nvim-neotest/neotest-go",
  --     "nvim-neotest/nvim-nio",
  --   },
  --   config = function()
  --     ---@diagnostic disable-next-line: different-requires
  --     require "configs.neotest"
  --   end,
  -- },
  -- {
  --   "andythigpen/nvim-coverage",
  --   ft = { "go", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  --   opts = {
  --     auto_reload = true,
  --     lang = {
  --       go = {
  --         coverage_file = vim.fn.getcwd() .. "/coverage.out",
  --       },
  --     },
  --     signs = {
  --       covered = { hl = "CoverageCovered", text = "│" },
  --       uncovered = { hl = "CoverageUncovered", text = "│" },
  --     },
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-lint",
  --   dependencies = { "rshkarin/mason-nvim-lint" },
  --   event = {
  --     "BufReadPre",
  --     "BufNewFile",
  --   },
  --   config = function()
  --     require "configs.linter"
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    dependencies = { "zapling/mason-conform.nvim" },
    config = function()
      require "configs.conform"
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "chrisgrieser/nvim-recorder",
    keys = { "<leader>qs" },
    opts = {
      slots = { "a", "b", "c", "d", "e", "f", "g" },
      mapping = {
        startStopRecording = "<leader>qs",
        playMacro = "Q",
        editMacro = "<leader>qe",
        switchSlot = "<leader>qt",
      },
      lessNotifications = true,
      clear = false,
      logLevel = vim.log.levels.INFO,
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufRead",
    opts = {
      prompt_func_return_type = {
        go = true,
      },
      prompt_func_param_type = {
        go = true,
      },
    },
  },
  ----------------------------------------- completions plugins ------------------------------------------
  -- {
  --   "skywind3000/gutentags_plus",
  --   event = "VeryLazy",
  --   dependencies = { "ludovicchabant/vim-gutentags" },
  --   config = function()
  --     require "configs.tags"
  --   end,
  -- },
  -- {
  --   "github/copilot.vim",
  --   lazy = false,
  --   config = function()
  --     require("copilot").setup()
  --     vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
  --     vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#03a598" })
  --   end,
  -- },
}
