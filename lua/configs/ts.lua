local baseDefinitionHandler = vim.lsp.handlers["textDocument/definition"]
local on_attach = require("nvchad.configs.lspconfig").on_attach

local shouldIgnoreFile = function(uri)
  return uri and (string.match(uri, "node_modules") or string.match(uri, "%.d%.ts$"))
end

local handlers = {
  ["textDocument/definition"] = function(err, result, method, ...)
    if err then
      vim.notify("LSP error: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if result and #result > 0 then
      local filtered_result = {}
      for _, item in ipairs(result) do
        if not shouldIgnoreFile(item.uri or item.targetUri) then
          table.insert(filtered_result, item)
        end
      end

      if #filtered_result == 0 then
        vim.notify("Lsp: node_modules and .d.ts ignored.", vim.log.levels.INFO)
        return
      end
      return baseDefinitionHandler(err, filtered_result, method, ...)
    end
  end,
}

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  -- Check if Glance is available
  local ok, _ = pcall(require, "glance")
  if not ok then
    vim.notify("Glance is not installed", vim.log.levels.WARN)
    return
  end

  -- Define keymaps with descriptions
  local opts = { buffer = bufnr, desc = "Glance: " }
  vim.keymap.set(
    "n",
    "gd",
    "<CMD>Glance definitions<CR>",
    vim.tbl_extend("force", opts, { desc = "Glance: Go to definition" })
  )
  vim.keymap.set(
    "n",
    "gy",
    "<CMD>Glance type_definitions<CR>",
    vim.tbl_extend("force", opts, { desc = "Glance: Go to type definition" })
  )
  vim.keymap.set(
    "n",
    "gr",
    "<CMD>Glance references<CR>",
    vim.tbl_extend("force", opts, { desc = "Glance: Find references" })
  )
  vim.keymap.set(
    "n",
    "gm",
    "<CMD>Glance implementations<CR>",
    vim.tbl_extend("force", opts, { desc = "Glance: Go to implementation" })
  )
end

require("typescript-tools").setup {
  on_attach = custom_on_attach,
  handlers = handlers,

  settings = {
    separate_diagnostic_server = true,
    expose_as_code_action = { "all" },
    tsserver_file_preferences = {
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
      includeCompletionsForImportStatements = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithClassMemberSnippets = true,
      includeCompletionsWithObjectLiteralMethodSnippets = true,
      importModuleSpecifierPreference = "project-relative",
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    tsserver_format_options = {
      allowIncompleteCompletions = true,
      allowRenameOfImportPath = true,
    },
    tsserver_plugins = {
      "@styled/typescript-styled-plugin",
    },
    tsserver_max_memory = 4096,
    -- code_lens = "all",
    jsx_close_tag = {
      enable = true,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      importModuleSpecifierPreference = "project-relative",
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      importModuleSpecifierPreference = "project-relative",
    },
  },
}
