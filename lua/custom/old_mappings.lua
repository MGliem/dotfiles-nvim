local M = {}

M.folder = {}

M.comment = {
  plugin = true,
}

M.development = {}

M.text = {
  n = {
    ["J"] = { "mzJ`z", "Join line while keeping the cursor in the same position" },
    ["<C-r>"] = { "<CMD>redo<CR>", "󰑎 Redo" },
    ["<leader><leader>p"] = { "printf('`[%s`]', getregtype()[0])", "Reselect last pasted area", expr = true },
    ["<leader>sp"] = { "<CMD>:TSJToggle<CR>", "󰯌 Toggle split/join" },
  },

  v = {
    ["y"] = { "y`]", "Yank and move to end" },
    -- Indent backward/forward:
    ["<"] = { "<gv", " Ident backward", opts = { silent = false } },
    [">"] = { ">gv", " Ident forward", opts = { silent = false } },
  },
}

M.window = {
  n = {
    ["<leader><leader>v"] = { "<CMD>vs <CR>", "󰤼 Vertical split", opts = { nowait = true } },
    ["<leader><leader>h"] = { "<CMD>sp <CR>", "󰤻 Horizontal split", opts = { nowait = true } },
  },
}

M.general = {
  n = {
    ["<leader>tr"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "󰂵 Toggle transparency",
    },
  },
}

M.node = {
  n = {
    ["<leader>ns"] = {
      function()
        require("package-info").show()
      end,
      "󰎙 Show package info",
    },
    ["<leader>up"] = {
      function()
        require("package-info").update()
      end,
      "󰎙 Update package",
    },
    ["<leader>nd"] = {
      function()
        require("package-info").delete()
      end,
      "󰎙 Delete package",
    },
    ["<leader>np"] = {
      function()
        require("package-info").change_version()
      end,
      "󰎙 Install package",
    },
  },
}

M.debug = {}

M.git = {
  n = {
    ["<leader>gb"] = { "<CMD>Telescope git_branches<CR>", "  Git branches" },
    ["<leader>gs"] = { "<CMD>Telescope git_status<CR>", "  Git status" },
    ["<leader>lg"] = { "<CMD>LazyGit<CR>", "  LazyGit" },
    ["<leader>gl"] = { "<CMD>GitBlameToggle<CR>", "  Blame line" },
    ["<leader>gtb"] = { "<CMD>ToggleBlame<CR>", "  Blame line" },

    ["<leader>gvd"] = { "<CMD> DiffviewOpen<CR>", "  Show git diff" },
    ["<leader>gvf"] = { "<CMD> DiffviewFileHistory %<CR>", "  Show file history" },
    ["<leader>gvp"] = { "<CMD> DiffviewOpen --cached<CR>", "  Show staged diffs" },
    ["<leader>gvr"] = { "<CMD> DiffviewRefresh<CR>", "  Refresh diff view" },
    ["<leader>gvc"] = { "<CMD> DiffviewClose<CR>", "  Close diff view" },

    ["<Leader>gcb"] = { "<CMD>ConflictMarkerBoth<CR>", "Choose both" },
    ["<Leader>gcn"] = { "<CMD>ConflictMarkerNextHunk<CR>", "Move to next conflict" },
    ["<Leader>gco"] = { "<CMD>ConflictMarkerOurselves<CR>", "Choose ours" },
    ["<Leader>gcp"] = { "<CMD>ConflictMarkerNextHunk<CR>", "Move to prev conflict" },
    ["<Leader>gct"] = { "<CMD>ConflictMarkerThemselves<CR>", "Choose theirs" },
  },
}

M.telescope = {
  n = {
    ["<leader>li"] = { "<CMD>Telescope highlights<CR>", "Highlights" },
    ["<leader>fk"] = { "<CMD>Telescope keymaps<CR>", " Find keymaps" },
    ["<leader>fs"] = { "<CMD>Telescope lsp_document_symbols<CR>", " Find document symbols" },
    -- ["<leader>fa"] = {
    --   function()
    --     require("search").open()
    --   end,
    --   " Find",
    -- },
    ["<leader>fu"] = { "<CMD>Telescope undo<CR>", " Undo tree" },
    ["<leader>fre"] = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      "Refactor",
    },
    ["<leader>fz"] = {
      "<CMD>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<CR>",
      " Find current file",
    },
    ["<leader>ff"] = {
      function()
        local builtin = require "telescope.builtin"
        -- ignore opened buffers if not in dashboard or directory
        if vim.fn.isdirectory(vim.fn.expand "%") == 1 or vim.bo.filetype == "alpha" then
          builtin.find_files()
        else
          local function literalize(str)
            return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)
              return "%" .. c
            end)
          end

          local function get_open_buffers()
            local buffers = {}
            local len = 0
            local vim_fn = vim.fn
            local buflisted = vim_fn.buflisted

            for buffer = 1, vim_fn.bufnr "$" do
              if buflisted(buffer) == 1 then
                len = len + 1
                -- get relative name of buffer without leading slash
                buffers[len] = "^"
                  .. literalize(string.gsub(vim.api.nvim_buf_get_name(buffer), literalize(vim.loop.cwd()), ""):sub(2))
                  .. "$"
              end
            end

            return buffers
          end

          builtin.find_files {
            file_ignore_patterns = get_open_buffers(),
          }
        end
      end,
      "Find files",
    },
  },
}

M.tabufline = {
  plugin = false,

  -- n = {
  --   -- cycle through buffers
  --   ["<S-L>"] = {
  --     function()
  --       require("nvchad.tabufline").next()
  --     end,
  --     " Goto next buffer",
  --   },
  --
  --   ["<D-l>"] = {
  --     function()
  --       require("nvchad.tabufline").prev()
  --     end,
  --     " Goto prev buffer",
  --   },
  --
  --   -- close buffer + hide terminal buffer
  --   ["<C-x>"] = {
  --     function()
  --       require("nvchad.tabufline").close_buffer()
  --     end,
  --     " Close buffer",
  --   },
  --
  --   -- close all buffers
  --   ["<leader>bx"] = {
  --     function()
  --       local current_buf = vim.api.nvim_get_current_buf()
  --       local all_bufs = vim.api.nvim_list_bufs()
  --
  --       for _, buf in ipairs(all_bufs) do
  --         if buf ~= current_buf and vim.fn.getbufinfo(buf)[1].changed ~= 1 then
  --           vim.api.nvim_buf_delete(buf, { force = true })
  --         end
  --       end
  --     end,
  --     " Close all but current buffer",
  --   },
  -- },
}

M.docker = {}

M.searchbox = {}

M.lspsaga = {
  n = {
    ["<leader>."] = {
      function()
        require("actions-preview").code_actions()
        -- require("tiny-code-action").code_action()
      end,
      "󰅱 Code Action",
    },
    ["<leader>k"] = {
      require("hover").hover,
      "󱙼 Hover lsp",
    },
    --  LSP
    ["<leader>qf"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "󰁨 Lsp Quickfix",
    },
  },
}

M.nvterm = {}

M.harpoon = {}

M.lspconfig = {}

return M
