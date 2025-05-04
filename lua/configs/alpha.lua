local alpha = require "alpha"
local dashboard = require "alpha.themes.dashboard"
_Gopts = {
  position = "center",
  hl = "Type",
  wrap = "overflow",
}

local function get_all_files_in_dir(dir)
  local files = {}
  local scan = vim.fn.globpath(dir, "**/*.lua", true, true)
  for _, file in ipairs(scan) do
    table.insert(files, file)
  end
  return files
end

local function load_random_header()
  math.randomseed(os.time())
  local header_folder = vim.fn.stdpath "config" .. "/lua/custom/header_img/"
  local files = get_all_files_in_dir(header_folder)

  if #files == 0 then
    return nil
  end

  local random_file = files[math.random(#files)]
  local relative_path = random_file:sub(#header_folder + 1)
  local module_name = "custom.header_img." .. relative_path:gsub("/", "."):gsub("\\", "."):gsub("%.lua$", "")

  package.loaded[module_name] = nil

  local ok, module = pcall(require, module_name)
  if ok and module.header then
    return module.header
  else
    return nil
  end
end

local function change_header()
  local new_header = load_random_header()
  if new_header then
    dashboard.config.layout[2] = new_header
    vim.cmd "AlphaRedraw"
  else
    print "No images inside header_img folder."
  end
end

local header = load_random_header()
if header then
  dashboard.config.layout[2] = header
else
  print "No images inside header_img folder."
end

vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#a8f4cb" })

vim.api.nvim_set_hl(0, "AlphaButtonText", { fg = "#ffe6c1", bold = true })

local buttonhl = function(shortcut, text, command)
  local button = dashboard.button(shortcut, text, command)
  button.opts.hl_shortcut = "AlphaButton"
  button.opts.hl = "AlphaButtonText"
  return button
end

dashboard.section.buttons.val = {
  buttonhl("e", "  > New file", ":ene <BAR> startinsert <CR>"),
  buttonhl("f", "󰈞  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
  buttonhl("r", "  > Recent", ":Telescope oldfiles<CR>"),
  buttonhl("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
  buttonhl("w", "󰚰  > Change header image", function()
    change_header()
  end),
  buttonhl("u", "  > Update plugins", "<cmd>Lazy update<CR>"),
  buttonhl("q", "󰩈  > Quit NVIM", ":qa<CR>"),
}

dashboard.config.layout = {
  { type = "padding", val = 2 },
  header,
  { type = "padding", val = 2 },
  {
    type = "group",
    val = {
      {
        type = "group",
        val = dashboard.section.buttons.val,
        opts = { spacing = 1 },
      },
    },
    opts = {
      layout = "horizontal",
    },
  },
  { type = "padding", val = 2 },
  dashboard.section.footer,
}
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  desc = "Add Alpha dashboard footer",
  once = true,
  callback = function()
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    dashboard.section.footer.val = { " ", " ", " ", " Loaded " .. stats.count .. " plugins  in " .. ms .. " ms " }
    pcall(vim.cmd.AlphaRedraw)
  end,
})

vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#9144db" })
dashboard.section.footer.opts.hl = "AlphaFooter"

-- dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)

vim.cmd [[
    autocmd FileType alpha setlocal nofoldenable
]]
