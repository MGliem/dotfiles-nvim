---@class ChadrcConfig
local M = {}

local core = require "custom.utils.core"

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"
M.ui = {
  lsp_semantic_tokens = false,
  statusline = core.statusline,
  tabufline = core.tabufline,

  cmp = {
    icons = true,
    lspkind_text = true,
    format_colors = {
      tailwind = true,
      icon = "󱓻",
    },
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "bordered" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.nvdash = core.nvdash

M.lsp = { signature = true }

M.term = {
  base46_colors = false,
}

M.base46 = {
  integrations = {
    "blankline",
    "cmp",
    "defaults",
    "devicons",
    "git",
    "lsp",
    "mason",
    "nvcheatsheet",
    "nvimtree",
    "statusline",
    "syntax",
    "tbline",
    "telescope",
    "whichkey",
    "dap",
    "hop",
    "treesitter",
    "todo",
    "notify",
  },

  theme = "catppuccin",
  theme_toggle = { "catppuccin", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.settings = {
  cc_size = "130",
  so_size = 10,

  -- Blacklisted files where cc and so must be disabled
  blacklist = {
    "NvimTree",
    "nvdash",
    "alpha",
    "nvcheatsheet",
    "terminal",
    "Trouble",
    "help",
  },
}

M.lazy_nvim = core.lazy

M.gitsigns = {
  signs = {
    add = { text = " " },
    change = { text = " " },
    delete = { text = " " },
    topdelete = { text = " " },
    changedelete = { text = " " },
    untracked = { text = " " },
  },
}

M.plugins = "custom.plugins"

-- TODO: Temporary fix for NvChad Mapping changes (I dont wanna edit all my mappings)
M.mappings = require "custom.old_mappings"
core.load_mappings "folder"
core.load_mappings "comment"
core.load_mappings "development"
core.load_mappings "text"
-- core.load_mappings "go"
core.load_mappings "window"
core.load_mappings "general"
-- core.load_mappings "diagnostics"
core.load_mappings "node"
-- core.load_mappings "debug"
core.load_mappings "git"
core.load_mappings "telescope"
core.load_mappings "tabufline"
core.load_mappings "docker"
core.load_mappings "searchbox"
core.load_mappings "lspsaga"
core.load_mappings "nvterm"
-- core.load_mappings "harpoon"
core.load_mappings "lspconfig"

return M
