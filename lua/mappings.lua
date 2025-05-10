require "nvchad.mappings"
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = 0 }

local function md_url_paste()
  -- Get clipboard
  local clip = vim.fn.getreg "+"
  -- 0-indexed locations
  local start_line = vim.fn.getpos("v")[2] - 1
  local start_col = vim.fn.getpos("v")[3] - 1
  local stop_line = vim.fn.getcurpos("")[2] - 1
  local stop_col = vim.fn.getcurpos("")[3] - 1
  -- Check start and stop aren't reversed, and swap if necessary
  if stop_line < start_line or (stop_line == start_line and stop_col < start_col) then
    start_line, start_col, stop_line, stop_col = stop_line, stop_col, start_line, start_col
  end
  -- Paste clipboard contents as md link.
  vim.api.nvim_buf_set_text(0, stop_line, stop_col + 1, stop_line, stop_col + 1, { "](" .. clip .. ")" })
  vim.api.nvim_buf_set_text(0, start_line, start_col, start_line, start_col, { "[" })
end

local function enter_undotree()
  vim.api.nvim_command "UndotreeShow"

  local is_glitched = vim.fn.getreg "%" == "undotree_2"

  if is_glitched then
    vim.api.nvim_command [[
            wincmd w
            wincmd w
            wincmd p
        ]]
  else
    vim.api.nvim_command "UndotreeFocus"
  end
end

--------------------------------------------------- Telescope --------------------------------------------------

map(
  "n",
  "<leader>bb",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
  { desc = "󰈚 Telescope Buffers" }
)

map("n", "<leader>yy", "<cmd>Telescope yank_history<cr>", { desc = "󰈚 Telescope Yank History" })
--------------------------------------------------- Buffers --------------------------------------------------

---navigate
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "󰈚 Buffer next" })
map("n", "<leader>bp", "<cmd>bprev<cr>", { desc = "󰈚 Buffer previous" })

---close
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "󰈚 Buffer close" })

---auto-save
map("n", "<leader>ts", "<cmd>Autosave toggle<cr>", { desc = "󰈚 Auto save" })
--------------------------------------------------- Editor ---------------------------------------------------

map("n", "<leader>pu", function()
  md_url_paste()
end, { desc = "Paste in URL" })

-- map({ "n", "t" }, "<A-g>", function()
--   require("nvchad.term").toggle {
--     cmd = "lazygit",
--     pos = "float",
--     id = "gitToggleTerm",
--     float_opts = {
--       width = 1,
--       height = 1,
--     },
--     clear_cmd = true,
--   }
-- end, { desc = "Toggle Lazygit" })

--Grug far ()
map("n", "<leader>sro", function()
  require("grug-far").open { transient = true }
end, { desc = "GrugFar Open" })
map("n", "<leader>srw", function()
  require("grug-far").open { transient = true, prefills = { search = vim.fn.expand "<cword>" } }
end, { desc = "GrugFar Word" })
map("n", "<leader>srv", function()
  require("grug-far").with_visual_selection { transient = true }
end, { desc = "GrugFar Visual" })

map("n", "<leader>srfw", function()
  require("grug-far").open {
    transient = true,
    prefills = { search = vim.fn.expand "<cword>", paths = vim.fn.expand "%" },
  }
end, { desc = "GrugFar File Word" })
map("n", "<leader>srfv", function()
  require("grug-far").with_visual_selection { transient = true, prefills = { paths = vim.fn.expand "%" } }
end, { desc = "GrugFar File Visual" })

-- GitSigns
map("n", "]c", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })

map({ "n" }, "<ESC>", function()
  vim.cmd "noh"
  vim.cmd "Noice dismiss"
end, { desc = " Clear highlights" })

map("n", "<leader>q", "<CMD>q<CR>", { desc = "󰗼 Close" })
map("n", "<leader>qq", "<CMD>qa!<CR>", { desc = "󰗼 Exit" })

-- NvimTree
map({ "n" }, "<leader>e", "<cmd>Oil<CR>", { desc = "󰔱 Toggle Oil" })
map({ "n", "i" }, "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })

map({ "n" }, "<leader>to", "<CMD>TSJToggle<CR>", { desc = "󱓡 Toggle split/join" })

---- undotree
map("n", "<leader>ut", function()
  enter_undotree()
end, { desc = " Undotree" })

--------------------------------------------------- Text ---------------------------------------------------
map("n", "<S-CR>", "o<ESC>", { desc = " New line" })
map("s", "<BS>", "<C-o>c", { desc = "Better backspace in select mode" })
map("n", "<C-a>", "<cmd>normal! ggVG<cr>", { desc = "Select all" })

map("i", "<S-CR>", function()
  vim.cmd "normal o"
end, { desc = " New line" })

map("i", "<A-BS>", "<C-w>", { desc = "Remove word in insert mode" })

-- Replaces the current word with the same word in uppercase, globally
map(
  "n",
  "<leader>sU",
  [[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "Replace current word with UPPERCASE" }
)

-- Replaces the current word with the same word in lowercase, globally
map(
  "n",
  "<leader>sL",
  [[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "Replace current word lowercas" }
)

-- Surround
-- map("x", "'", [[:s/\%V\(.*\)\%V/'\1'/ <CR>]], { dsc = "Surround selection with '" })
-- map("x", '"', [[:s/\%V\(.*\)\%V/"\1"/ <CR>]], { desc = 'Surround selection with "' })
-- map("x", "*", [[:s/\%V\(.*\)\%V/*\1*/ <CR>]], { desc = "Surround selection with *" })

map("n", "<leader>s*", [[:s/\<<C-r><C-w>\>/*<C-r><C-w>\*/ <CR>]], { desc = "Surround word with *" })
map("n", '<leader>s"', [[:s/\<<C-r><C-w>\>/"<C-r><C-w>\"/ <CR>]], { desc = 'Surround word with "' })
map("n", "<leader>s'", [[:s/\<<C-r><C-w>\>/'<C-r><C-w>\'/ <CR>]], { desc = "Surround word with '" })
map("n", "<leader>s(", [[:s/\<<C-r><C-w>\>/(<C-r><C-w>\)/ <CR>]], { desc = "Surround word with ()" })
map("n", "<leader>s{", [[:s/\<<C-r><C-w>\>/{<C-r><C-w>\}/ <CR>]], { desc = "Surround word with {}" })
map("n", "<leader>s[", [[:s/\<<C-r><C-w>\>/{<C-r><C-w>\}/ <CR>]], { desc = "Surround word with []" })

-- In visual mode, surround the selected text with markdown link syntax
map("v", "<leader>mll", function()
  -- delete selected text
  vim.cmd "normal d"
  -- Insert the following in insert mode
  vim.cmd "startinsert"
  vim.api.nvim_put({ "[]() " }, "c", true, true)
  -- Move to the left, paste, and then move to the right
  vim.cmd "normal F[pf)"
  -- vim.cmd("normal 2hpF[l")
  -- Leave me in insert mode to start typing
  vim.cmd "startinsert"
end, { desc = "[P]Convert to link" })

-- In visual mode, surround the selected text with markdown link syntax
map("v", "<leader>mlt", function()
  -- delete selected text
  vim.cmd "normal d"
  -- Insert the following in insert mode
  vim.api.nvim_put({ '[](){:target="_blank"} ' }, "c", true, true)
  vim.cmd "startinsert"
  vim.cmd "normal F[pf)"
  -- Leave me in insert mode to start typing
  vim.cmd "startinsert"
end, { desc = "[P]Convert to link (new tab)" })

--------------------------------------------------- Movements ---------------------------------------------------
-- map({ "n", "i" }, "<C-h>", function()
--   move_or_create_win "h"
-- end, { desc = "Split left" })
-- map({ "n", "i" }, "<C-l>", function()
--   move_or_create_win "l"
-- end, { desc = "Split right" })
-- map({ "n", "i" }, "<C-k>", function()
--   move_or_create_win "k"
-- end, { desc = "Split up" })
-- map({ "n", "i" }, "<C-j>", function()
--   move_or_create_win "j"
-- end, { desc = "Split down" })

-- Better Down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Better Down", expr = true, silent = true })

-- Better Up
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Better Up", expr = true, silent = true })

-- Hop
-- map("n", "<leader><leader>w", "<CMD> HopWord <CR>", { desc = "󰸱 Hint all words" })
-- map("n", "<leader><leader>t", "<CMD> HopNodes <CR>", { desc = " Hint Tree" })
-- map("n", "<leader><leader>o", "<CMD> HopLineStart<CR>", { desc = "󰕭 Hint Columns" })
-- map("n", "<leader><leader>l", "<CMD> HopWordCurrentLine<CR>", { desc = "󰗉 Hint Line" })

--Terminal
map({ "n", "t" }, "<leader>tf", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      row = 0.05,
      col = 0.05,
      width = 0.9,
      height = 0.8,
    },
  }
end, { desc = "terminal toggle floating term" })

-- Navigation
-- map("n", "<C-ScrollWheelUp>", "<C-i>", { noremap = true, silent = true })
-- map("n", "<C-ScrollWheelDown>", "<C-o>", { noremap = true, silent = true })

--------------------------------------------------- Testing ---------------------------------------------------
map("n", "<leader>nt", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "󰤑 Run neotest" })

map("n", "<leader>tc", "<cmd>CoverageToggle<cr>", { desc = "Coverage in gutter" })
map("n", "<leader><leader>c", "<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>", { desc = "Coverage summary" })
--------------------------------------------------- LSP ---------------------------------------------------
map("n", "K", function()
  local api = vim.api
  local hover_win = vim.b.hover_preview
  if hover_win and api.nvim_win_is_valid(hover_win) then
    api.nvim_set_current_win(hover_win)
  else
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      require("hover").hover()
    end
  end
end, { desc = "hover.nvim" })

map("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
map("n", "<leader>gy", "<CMD>Glance type_definitions<CR>", { desc = "Type definition" })
map("n", "<leader>gr", "<CMD>Glance references<CR>", { desc = "References" })
map("n", "<leader>gm", "<CMD>Glance implementations<CR>", { desc = "Implementations" })
map("n", "<leader>gd", "<CMD>Glance definitions<CR>", { desc = "Definitions" })

-- Folding with UFO
map("n", "zO", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zC", require("ufo").closeAllFolds, { desc = "Close all folds" })

-- vim.api.nvim_set_keymap('n', '<RightMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
map({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
map({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })
-- In visual mode, after going to the end of the line, come back 1 character
map("v", "gl", "$h", { desc = "[P]Go to the end of the line" })

-- add yours here
local keymap = vim.keymap.set
local silent = { silent = true }

-- Volt menu
-- Keyboard users
keymap("n", "<C-t>", function()
  require("menu").open "default"
end, {})

-- mouse users + nvimtree users!
keymap("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'

  require("menu").open("default", { mouse = true })
end, {})

-- Better window movement
keymap("n", "<C-h>", "<C-w>h", silent)
keymap("n", "<C-j>", "<C-w>j", silent)
keymap("n", "<C-k>", "<C-w>k", silent)
keymap("n", "<C-l>", "<C-w>l", silent)

-- H to move to the first non-blank character of the line
keymap("n", "H", "^", silent)

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", silent)
keymap("x", "J", ":move '>+1<CR>gv-gv", silent)

-- Keep visual mode indenting
keymap("v", "<", "<gv", silent)
keymap("v", ">", ">gv", silent)

-- indent in normal mode with <Tab>
keymap("n", "<Tab>", ">>", silent)
keymap("n", "<S-Tab>", "<<", silent)

-- Case change in visual mode
-- keymap("v", "`", "u", silent)
-- keymap("v", "<A-`>", "U", silent)

-- Save file by CTRL-S
-- keymap("n", "<C-s>", ":w<CR>", silent)
-- keymap("i", "<C-s>", "<ESC> :w<CR>", silent)

-- Don't yank on delete char
keymap("n", "x", '"_x', silent)
keymap("n", "X", '"_X', silent)
-- keymap("v", "x", '"_x', silent)
keymap("v", "X", '"_X', silent)

-- don't yank on delete visual
keymap("v", "d", '"_d', silent)

-- Don't yank on visual paste
-- keymap("v", "p", '"_dP', silent)
-- Don't yank on change
keymap("v", "c", '"_c', silent)
keymap("v", "C", '"_C', silent)
keymap("n", "C", '"_C', silent)
keymap("n", "c", '"_c', silent)

keymap({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
keymap({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
keymap({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
keymap({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
keymap("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keymap("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- Open links under cursor in browser with gx
keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)

------------------------------------------------- diagnostics ---------------------------------------------------

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<leader>tv", function()
  vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, { desc = "Toggle virtual text" })

map("n", "<leader>tl", function()
  vim.diagnostic.config { virtual_lines = not vim.diagnostic.config().virtual_lines }
end, { desc = "Toggle virtual text" })

keymap(
  "n",
  "<leader>gen",
  "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>",
  silent
)
keymap(
  "n",
  "<leader>gep",
  "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>",
  silent
)
keymap("n", "<leader>gef", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)

-- vtsls
-- keymap("n", "<leader>ci", "<cmd>VtsExec add_missing_imports<CR>", silent)
-- keymap("n", "<leader>cr", "<cmd>VtsExec remove_unused_imports<CR>", silent)
-- keymap("n", "<leader>cu", "<cmd>VtsExec remove_unused<CR>", silent)
-- keymap("n", "<leader>cf", "<cmd>VtsExec fix_all<CR>", silent)
-- keymap("n", "<leader>cc", "<cmd>VtsExec rename_file<CR>", silent)
-- keymap("n", "<leader>co", "<cmd>VtsExec organize_imports<CR>", silent)

keymap("n", "<leader>ci", "<cmd>TSToolsAddMissingImports<CR>", silent)
keymap("n", "<leader>cr", "<cmd>TSToolsRemoveUnusedImports<CR>", silent)
keymap("n", "<leader>cf", "<cmd>TSToolsFixAll<CR>", silent)

--session
keymap("n", "<leader>ss", "<cmd>SessionSave<CR>", silent)
keymap("n", "<leader>rs", "<cmd>SessionRestore<CR>", silent)

--lsp
-- keymap("n", "<leader>lr", "<cmd>LspRestart vtsls<CR>", silent)
-- keymap("n", "<leader>ls", "<cmd>LspStart vtsls<CR>", silent)
keymap("n", "<leader>cl", vim.lsp.codelens.run, { silent = true })
