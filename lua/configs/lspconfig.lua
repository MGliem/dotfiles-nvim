-- Load defaults from NvChad
require("nvchad.configs.lspconfig").defaults()

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
-- local builtin = require "telescope.builtin"

local on_attach = require("nvchad.configs.lspconfig").on_attach

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities(),
  require("nvchad.configs.lspconfig").capabilities
)

local present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if present then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local ok, ufo = pcall(require, "ufo")
if ok and ufo then
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
else
  vim.notify("UFO plugin not loaded; folding capabilities disabled.", vim.log.levels.WARN)
end

-- local function attach_codelens(client, bufnr)
--   local augroup = vim.api.nvim_create_augroup("Lsp", {})
--   vim.api.nvim_create_autocmd({ "BufReadPost", "CursorHold", "InsertLeave" }, {
--     group = augroup,
--     buffer = bufnr,
--     callback = function()
--       vim.lsp.codelens.refresh { bufnr = bufnr }
--     end,
--   })
-- end

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint(bufnr, true)
  -- end

  if client.server_capabilities.workspace.didChangeWatchedFiles then
    client.server_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  end

  -- if client.server_capabilities.textDocument then
  --   if client.server_capabilities.textDocument.codeLens then
  --     require("virtualtypes").on_attach(client, bufnr)
  --
  --     vim.api.nvim_create_autocmd({ "BufReadPost", "CursorHold", "InsertLeave" }, {
  --       buffer = bufnr,
  --       callback = function()
  --         vim.lsp.codelens.refresh { bufnr = bufnr }
  --       end,
  --     })
  --   end
  -- end

  if client.server_capabilities.signatureHelpProvider then
    vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
  end

  -- Code lens
  -- if client.server_capabilities.codeLensProvider then
  -- end

  -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

-- local filter_list = function(list, predicate)
--   -- empty list
--   local res_len = #list
--   local move_item_by = 0
--
--   for i = 1, res_len do
--     local item = list[i]
--     list[i] = nil
--     if not predicate(item) then
--       move_item_by = move_item_by - 1
--     else
--       list[i + move_item_by] = item
--     end
--   end
-- end

-- If the LSP response includes any `node_modules`, then try to remove them and
-- see if there are any options left. We probably want to navigate to the code
-- in OUR codebase, not inside `node_modules`.
--
-- This can happen if a type is used to explicitly type a variable:
-- ```ts
-- const MyComponent: React.FC<Props> = () => <div />
-- ````
--
-- Running "Go to definition" on `MyComponent` would give the `React.FC`
-- definition in `node_modules/react` as the first result, but we don't want
-- that.
local function filter_out_libraries_from_lsp_items(results)
  local without_node_modules = vim.tbl_filter(function(item)
    return item.targetUri and not string.match(item.targetUri, "node_modules")
  end, results)

  if #without_node_modules > 0 then
    return without_node_modules
  end

  return results
end

local function filter_out_same_location_from_lsp_items(results)
  return vim.tbl_filter(function(item)
    local from = item.originSelectionRange
    local to = item.targetSelectionRange

    return not (
      from
      and from.start.character == to.start.character
      and from.start.line == to.start.line
      and from["end"].character == to["end"].character
      and from["end"].line == to["end"].line
    )
  end, results)
end

-- This function is mostly copied from Telescope, I only added the
-- `node_modules` filtering.
local function list_or_jump(action, title, opts)
  opts = opts or {}

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, action, params, function(err, result, ctx, _)
    if err then
      vim.notify("Error when executing " .. action .. " : " .. err.message, vim.log.levels.ERROR)
      return
    end
    local flattened_results = {}
    if result then
      -- textDocument/definition can return Location or Location[]
      if not vim.islist(result) then
        flattened_results = { result }
      end

      vim.list_extend(flattened_results, result)
    end

    -- This is the only added step to the Telescope function
    flattened_results = filter_out_same_location_from_lsp_items(filter_out_libraries_from_lsp_items(flattened_results))

    local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

    if #flattened_results == 0 then
      return
    elseif #flattened_results == 1 and opts.jump_type ~= "never" then
      if opts.jump_type == "tab" then
        vim.cmd.tabedit()
      elseif opts.jump_type == "split" then
        vim.cmd.new()
      elseif opts.jump_type == "vsplit" then
        vim.cmd.vnew()
      end
      vim.lsp.util.jump_to_location(flattened_results[1], offset_encoding)
    else
      local locations = vim.lsp.util.locations_to_items(flattened_results, offset_encoding)
      pickers
        .new(opts, {
          prompt_title = title,
          finder = finders.new_table {
            results = locations,
            entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
          },
          previewer = conf.qflist_previewer(opts),
          sorter = conf.generic_sorter(opts),
        })
        :find()
    end
  end)
end

local function definitions(opts)
  return list_or_jump("textDocument/definition", "LSP Definitions", opts)
end

vim.lsp.handlers["textDocument/hover"] = require("noice").hover
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  if err or not result or not ctx then
    vim.notify("LSP diagnostics error: " .. (err or "unknown"), vim.log.levels.ERROR)
    return
  end

  local ts_lsp = { "vtsls", "angularls", "volar", "typescript-tools", "ts_lsp" }
  local clients = vim.lsp.get_clients { id = ctx.client_id }
  if clients[1] ~= nil then
    if vim.tbl_contains(ts_lsp, clients[1].name) then
      local ok, translated = pcall(function()
        return {
          diagnostics = vim.tbl_filter(function(d)
            return d.severity == 1
          end, result.diagnostics),
        }
      end)
      if ok and translated then
        require("ts-error-translator").translate_diagnostics(err, translated, ctx, config)
      end
    end
  end
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

local servers = {
  "bashls",
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "vtsls",
  "marksman",
  "tailwindcss",
  "dockerls",
  "yamlls",
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

vim.lsp.config("eslint", {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  cmd = { "vscode-eslint-language-server", "--stdio" },
  handlers = {
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,

    ["eslint/noLibrary"] = function()
      vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,

    ["eslint/openDoc"] = function(_, result)
      if not result then
        return
      end
      local sysname = vim.loop.os_uname().sysname
      if sysname:match "Windows_NT" then
        os.execute(string.format("start %q", result.url))
      elseif sysname:match "Linux" then
        os.execute(string.format("xdg-open %q", result.url))
      else
        os.execute(string.format("open %q", result.url))
      end
      return {}
    end,

    ["eslint/probeFailed"] = function()
      vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
  },
  -- root_dir = require("lspconfig").util.root_pattern(
  --   ".eslintrc",
  --   ".eslintrc.js",
  --   ".eslintrc.cjs",
  --   ".eslintrc.yaml",
  --   ".eslintrc.yml",
  --   ".eslintrc.json",
  --   "package.json"
  -- ),
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
    codeActionOnSave = {
      enable = false,
      mode = "all",
    },
    format = true,
    nodePath = "",
    onIgnoredFiles = "off",
    packageManager = "npm",
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "location",
    },
  },
})

vim.lsp.config("jsonls", {
  -- on_attach = custom_on_attach,
  -- capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("lua_ls", {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "use", "vim" },
      },
      hint = {
        enable = true,
        setType = true,
      },
      telemetry = {
        enable = false,
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

vim.lsp.config("vtsls", {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "astro",
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = false,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 50,
        },
        diagnostics = {
          debounce = 500, -- Délai en millisecondes
        },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      preferences = {
        importModuleSpecifier = "project-relative",
        includePackageJsonAutoImports = "off",
        autoImportFileExcludePatterns = { ".git" },
      },
    },
    typescript = {
      tsserver = {
        maxTsServerMemory = 4096,
      },
      format = {
        indentSize = vim.o.shiftwidth,
        convertTabsToSpaces = vim.o.expandtab,
        tabSize = vim.o.tabstop,
      },
      preferences = {
        importModuleSpecifier = "project-relative",
        includePackageJsonAutoImports = "off",
        autoImportFileExcludePatterns = { ".git" },
      },
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = false },
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
})

-- for _, server in ipairs(servers) do
--   vim.lsp.enable(server, true)
-- end

require("mason-lspconfig").setup {
  ensure_installed = servers,
  automatic_enable = true,
}

vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx, _)
  if err or not result or not ctx or not ctx.bufnr or not vim.api.nvim_buf_is_valid(ctx.bufnr) then
    vim.notify("LSP formatting error: " .. (err or "invalid buffer"), vim.log.levels.ERROR)
    return
  end

  if not vim.bo[ctx.bufnr].modified then
    local view = vim.fn.winsaveview()
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client and client.offset_encoding then
      pcall(vim.lsp.util.apply_text_edits, result, ctx.bufnr, client.offset_encoding)
    end
    vim.fn.winrestview(view)
    if ctx.bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command "noautocmd :update"
    end
  end
end

-- vim.lsp.handlers["textDocument/inlayHint"] = function(result)
--   filter_list(result, function(item)
--     if
--       item.label == "x:"
--       or item.label == "y:"
--       or item.label == "z:"
--       or item.label == "a:"
--       or item.label == "b:"
--       or item.label == "v:"
--       or item.label == "m:"
--       or item.label == "s:"
--       or item.label == "nptr:"
--       or item.label == "scalar:"
--       or item.lable == "argv0"
--     then
--       return false
--     end
--     -- local line = item.position.line
--     -- local col = item.position.character
--     -- local node = vim.treesitter.get_node({pos = {line,col}})
--     -- I(vim.treesitter.get_node_text(node:parent(), 0))
--     return true
--   end)
--   -- accept request.
--   return true
-- end

require("lspconfig.ui.windows").default_options.border = "rounded"

-- local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
--
-- for type, icon in pairs(signs) do
--   local hl = "Diagnostic" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

local x = vim.diagnostic.severity
vim.diagnostic.config {

  virtual_lines = false,
  -- virtual_text = {
  --   prefix = "■",
  --   spacing = 2,
  -- },
  virtual_text = false,
  float = {
    border = "rounded",
    format = function(diagnostic)
      if diagnostic.source == "eslint" then
        return string.format(
          "%s [%s]",
          diagnostic.message,
          -- shows the name of the rule
          diagnostic.user_data.lsp.code
        )
      end

      local message = diagnostic.message

      if diagnostic.source then
        message = string.format("%s %s", diagnostic.message, diagnostic.source)
      end
      if diagnostic.code then
        message = string.format("%s[%s]", diagnostic.message, diagnostic.code)
      end

      return message
    end,
    suffix = function()
      return ""
    end,
    severity_sort = true,
    close_events = { "CursorMoved", "InsertEnter" },
  },
  signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--   callback = function(event)
--     -- Set up keymaps
--     local opts = { buffer = event.buf, silent = true }
--     local client = vim.lsp.get_client_by_id(event.data.client_id)
--
--     vim.keymap.set("n", "<c-}>", function()
--       definitions()
--     end, opts)
--
--     -- Mouse mappings for easily navigating code
--     -- if client.supports_method "definitionProvider" then
--     --   vim.keymap.set("n", "<RightMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", opts)
--     -- end
--   end,
-- })
--
-- local function best_diagnostic(diagnostics)
--   if vim.tbl_isempty(diagnostics) then
--     return
--   end
--
--   local best = nil
--   local line_diagnostics = {}
--   local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
--
--   for k, v in pairs(diagnostics) do
--     if v.lnum == line_nr then
--       line_diagnostics[k] = v
--     end
--   end
--
--   for _, diagnostic in ipairs(line_diagnostics) do
--     if best == nil then
--       best = diagnostic
--     elseif diagnostic.severity < best.severity then
--       best = diagnostic
--     end
--   end
--
--   return best
-- end
--
-- local function current_line_diagnostics()
--   local bufnr = 0
--   local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
--   local opts = { ["lnum"] = line_nr }
--
--   return vim.diagnostic.get(bufnr, opts)
-- end
-- --
-- local virt_handler = vim.diagnostic.handlers.virtual_text
-- local ns = vim.api.nvim_create_namespace "current_line_virt"
-- local severity = vim.diagnostic.severity
-- local virt_options = {
--   prefix = "",
--   format = function(diagnostic)
--     local message = vim.split(diagnostic.message, "\n")[1]
--
--     if diagnostic.severity == severity.ERROR then
--       return signs.Error .. message
--     elseif diagnostic.severity == severity.INFO then
--       return signs.Info .. message
--     elseif diagnostic.severity == severity.WARN then
--       return signs.Warn .. message
--     elseif diagnostic.severity == severity.HINT then
--       return signs.Hint .. message
--     else
--       return message
--     end
--   end,
-- }
-- --
-- vim.diagnostic.handlers.current_line_virt = {
--   show = function(_, bufnr, diagnostics, _)
--     local diagnostic = best_diagnostic(diagnostics)
--     if not diagnostic then
--       return
--     end
--
--     local filtered_diagnostics = { diagnostic }
--
--     virt_handler.hide(ns, vim.api.nvim_get_current_buf())
--     pcall(virt_handler.show, ns, bufnr, filtered_diagnostics, { virtual_text = virt_options })
--   end,
--   hide = function(_, bufnr)
--     bufnr = bufnr or vim.api.nvim_get_current_buf()
--     virt_handler.hide(ns, bufnr)
--   end,
-- }
--
-- vim.api.nvim_create_augroup("lsp_diagnostic_current_line", {
--   clear = true,
-- })
--
-- vim.api.nvim_clear_autocmds {
--   group = "lsp_diagnostic_current_line",
-- }
--
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   group = "lsp_diagnostic_current_line",
--   callback = function()
--     vim.diagnostic.handlers.current_line_virt.show(nil, 0, current_line_diagnostics(), nil)
--   end,
-- })
--
-- local line = nil
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   group = "lsp_diagnostic_current_line",
--   callback = function()
--     local next_line = vim.api.nvim_win_get_cursor(0)[1] - 1
--
--     if line ~= next_line then
--       line = next_line
--       vim.diagnostic.handlers.current_line_virt.hide(nil, nil)
--     end
--   end,
-- })
-- require("lspconfig.configs").vtsls = require("vtsls").lspconfig

-- tree auto rename paths update with vtsls

local path_sep = package.config:sub(1, 1)

local function trim_sep(path)
  return path:gsub(path_sep .. "$", "")
end

local function uri_from_path(path)
  return vim.uri_from_fname(trim_sep(path))
end

local function is_sub_path(path, folder)
  path = trim_sep(path)
  folder = trim_sep(folder)
  if path == folder then
    return true
  else
    return path:sub(1, #folder + 1) == folder .. path_sep
  end
end

local function check_folders_contains(folders, path)
  for _, folder in pairs(folders) do
    if is_sub_path(path, folder.name) then
      return true
    end
  end
  return false
end

local function match_file_operation_filter(filter, name, type)
  if filter.scheme and filter.scheme ~= "file" then
    -- we do not support uri scheme other than file
    return false
  end
  local pattern = filter.pattern
  local matches = pattern.matches

  if type ~= matches then
    return false
  end

  local regex_str = vim.fn.glob2regpat(pattern.glob)
  if vim.tbl_get(pattern, "options", "ignoreCase") then
    regex_str = "\\c" .. regex_str
  end
  return vim.regex(regex_str):match_str(name) ~= nil
end

local api = require "nvim-tree.api"
api.events.subscribe(api.events.Event.NodeRenamed, function(data)
  local stat = vim.loop.fs_stat(data.new_name)
  if not stat then
    return
  end
  local type = ({ file = "file", directory = "folder" })[stat.type]
  local clients = vim.lsp.get_clients {}
  for _, client in ipairs(clients) do
    if check_folders_contains(client.workspace_folders, data.old_name) then
      local filters = vim.tbl_get(client.server_capabilities, "workspace", "fileOperations", "didRename", "filters")
        or {}
      for _, filter in pairs(filters) do
        if
          match_file_operation_filter(filter, data.old_name, type)
          and match_file_operation_filter(filter, data.new_name, type)
        then
          client:notify(
            "workspace/didRenameFiles",
            { files = { { oldUri = uri_from_path(data.old_name), newUri = uri_from_path(data.new_name) } } }
          )
        end
      end
    end
  end
end)
