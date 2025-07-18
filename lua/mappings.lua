require "nvchad.mappings"
local map = vim.keymap.set
local unmap = vim.keymap.del
local opts = { noremap = true, silent = true, buffer = 0 }
local silent = { silent = true }

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

--disable nvchads default new buffer
unmap("n", "<leader>b")
--disable nchads terminal buffers
unmap("n", "<leader>h")
unmap("n", "<leader>v")

map("n", "<leader>ba", "<cmd>enew<cr>", { desc = "󰈚 Add/New buffer" })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "󰈚 Buffer next" })
map("n", "<leader>bp", "<cmd>bprev<cr>", { desc = "󰈚 Buffer previous" })
map("n", "<leader>bl", "<cmd>blast<cr>", { desc = "󰈚 Buffer last" })

map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "󰈚 Buffer close" })
map("n", "<leader>bc", "<cmd>bdelete!<cr>", { desc = "󰈚 Buffer close Forced(!)" })

map("n", "<leader>bx", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(all_bufs) do
    if buf ~= current_buf and vim.fn.getbufinfo(buf)[1].changed ~= 1 then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = " Close all but current buffer" })

---auto-save
map("n", "<leader>ts", "<cmd>ASToggle<cr>", { desc = "󰈚 Auto-save toggle" })

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
map(
  "n",
  "<leader><leader>th",
  "<cmd>lua require('nvchad.term').toggle { pos = 'horizontal' }<cr>",
  { desc = "terminal toggle horizontal term" }
)
map(
  "n",
  "<leader><leader>tv",
  "<cmd>lua require('nvchad.term').toggle { pos = 'vertical' }<cr>",
  { desc = "terminal toggle vertical term" }
)
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
map("v", "<leader>srv", function()
  require("grug-far").with_visual_selection { transient = true }
end, { desc = "GrugFar Visual" })

map("n", "<leader>srfw", function()
  require("grug-far").open {
    transient = true,
    prefills = { search = vim.fn.expand "<cword>", paths = vim.fn.expand "%" },
  }
end, { desc = "GrugFar File Word" })
map("v", "<leader>srfv", function()
  require("grug-far").with_visual_selection { transient = true, prefills = { paths = vim.fn.expand "%" } }
end, { desc = "GrugFar File Visual" })
map("n", "<leader>srfo", function()
  require("grug-far").open {
    transient = true,
    prefills = { paths = vim.fn.expand "%" },
  }
end, { desc = "GrugFar File" })

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

--luasnip
local ls = require "luasnip"

map({ "i" }, "<C-K>", function()
  ls.expand()
end, { silent = true })
map({ "i", "s" }, "<C-L>", function()
  ls.jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-J>", function()
  ls.jump(-1)
end, { silent = true })

map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

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

-- Paste Image
map("n", "<leader><leader>ip", "<cmd>PasteImage<cr>", { desc = "Paste image" })

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

-- Better window movement
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)

--move middle of text
map("n", "m", ":exe 'normal '.(virtcol('$')/2).'|'<cr>", silent)
-- H to move to the first non-blank character of the line
map("n", "H", "^", silent)

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", silent)
map("x", "J", ":move '>+1<CR>gv-gv", silent)

-- Keep visual mode indenting
map("v", "<", "<gv", silent)
map("v", ">", ">gv", silent)

-- indent in normal mode with <Tab>
map("n", "<Tab>", ">>", silent)
map("n", "<S-Tab>", "<<", silent)

-- Case change in visual mode
-- map("v", "`", "u", silent)
-- map("v", "<A-`>", "U", silent)

-- Don't yank on delete char
-- map("n", "x", '"_x', silent)
-- map("n", "X", '"_X', silent)
-- map("v", "x", '"_x', silent)
-- map("v", "X", '"_X', silent)

-- don't yank on delete
-- map("v", "d", '"_d', silent)
map("n", "dd", '<S-v>"_d', silent)
-- map("n", "d$", 'v$"_d', silent)

-- Don't yank on visual paste
-- map("v", "p", '"_dP', silent)
-- Don't yank on change
-- map("v", "c", '"_c', silent)
-- map("v", "C", '"_C', silent)
-- map("n", "C", '"_C', silent)
-- map("n", "c", '"_c', silent)

-- Navigation
-- map("n", "<C-ScrollWheelUp>", "<C-i>", { noremap = true, silent = true })
-- map("n", "<C-ScrollWheelDown>", "<C-o>", { noremap = true, silent = true })

--------------------------------------------------- Testing ---------------------------------------------------
-- map("n", "<leader>nt", function()
--   require("neotest").run.run(vim.fn.expand "%")
-- end, { desc = "󰤑 Run neotest" })
--
-- map("n", "<leader>tc", "<cmd>CoverageToggle<cr>", { desc = "Coverage in gutter" })
-- map("n", "<leader><leader>c", "<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>", { desc = "Coverage summary" })

--------------------------------------------------- Debugging ---------------------------------------------------

map("n", "<leader>cl", "yiwoconsole.log('<Esc>pa: ', <Esc>pa);", { desc = "Console.log" })

--------------------------------------------------- LSP ---------------------------------------------------
map("n", "<leader>wd", function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
  end
end, {
  desc = "Populate workspace diagnostics",
})

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

-- Volt menu
-- Keyboard users
map("n", "<C-t>", function()
  require("menu").open "default"
end, {})

-- mouse users + nvimtree users!
map("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'

  require("menu").open("default", { mouse = true })
end, {})

map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- Open links under cursor in browser with gx
map("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)

-- transform as import type
map(
  "n",
  "<leader>ctw",
  'viwxv"_dv"_doimport type { <Esc>pa }<Esc>k$vT}yj$p',
  { desc = "Transform word under cursor as import type" }
)

map("n", "<leader>ctl", "^ea type<Esc>", { desc = "Import type same line" })

--Format with conform
map("n", "<leader>fm", function()
  require("conform").format { async = true, quiet = true }
end, { desc = " Conform formatting" })

--Invert text with nvim-toggler (example: true <=> false)
map("n", "<leader>i", function()
  require("nvim-toggler").toggle()
end, { desc = "󰌁 Invert text" })

------------------------------------------------- diagnostics ---------------------------------------------------

map("n", "<leader>da", function()
  require("wtf").ai()
end, { desc = "Debug diagnostic with AI" })

map("n", "<leader>dw", function()
  require("wtf").search()
end, { desc = "Search diagnostic with Google" })

map("n", "<leader>dh", function()
  require("wtf").history()
end, { desc = "Populate the quickfix list with previous chat history" })

map("n", "<leader>dg", function()
  require("wtf").grep_history()
end, { desc = "Grep previous chat history with Telescope" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<leader>tv", function()
  vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, { desc = "Toggle virtual text" })

map("n", "<leader>tl", function()
  vim.diagnostic.config { virtual_lines = not vim.diagnostic.config().virtual_lines }
end, { desc = "Toggle virtual text" })

map(
  "n",
  "<leader>gen",
  "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = { border = 'rounded', max_width = 100 }})<CR>",
  { desc = "Next error" }
)
map(
  "n",
  "<leader>gep",
  "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = { border = 'rounded', max_width = 100 }})<CR>",
  { desc = "Previous error" }
)
-- map("n", "<leader>ci", "<cmd>TSToolsAddMissingImports<CR>", silent)
-- map("n", "<leader>cr", "<cmd>TSToolsRemoveUnusedImports<CR>", silent)
-- map("n", "<leader>cf", "<cmd>TSToolsFixAll<CR>", silent)
map("n", "<leader>ci", "<cmd>VtsExec add_missing_imports<CR>", silent)
map("n", "<leader>cr", "<cmd>VtsExec remove_unused_imports<CR>", silent)
map("n", "<leader>cf", "<cmd>VtsExec fix_all<CR>", silent)

---------------------------------------------------- Session ---------------------------------------------------
map("n", "<leader>ss", "<cmd>SessionSave<CR>", silent)
map("n", "<leader>rs", "<cmd>SessionRestore<CR>", silent)
