local present, autoSave = pcall(require, "auto-save")
if not present then
  return
end

local group = vim.api.nvim_create_augroup("autosave", {})

vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveEnable",
  group = group,
  callback = function(opts)
    vim.notify("AutoSave enabled", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveDisable",
  group = group,
  callback = function(opts)
    vim.notify("AutoSave disabled", vim.log.levels.INFO)
  end,
})

autoSave.setup {
  -- The name of the augroup.
  augroup_name = "AutoSavePlug",
  -- execution_message = {
  --   message = function()
  --     return ""
  --   end,
  --   dim = 0.18,
  --   cleaning_interval = 1250,
  -- },
  events = { "InsertLeave", "TextChanged" },
  silent = true,
  enabled  = false,
  callbacks = {
    before_saving = function()
      -- save global autoformat status
      vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled

      vim.g.autoformat_enabled = false
      vim.g.OLD_AUTOFORMAT_BUFFERS = {}
      -- disable all manually enabled buffers
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.b[bufnr].autoformat_enabled then
          table.insert(vim.g.OLD_BUFFER_AUTOFORMATS, bufnr)
          vim.b[bufnr].autoformat_enabled = false
        end
      end
    end,
    after_saving = function()
      -- restore global autoformat status
      vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
      -- reenable all manually enabled buffers
      for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
        vim.b[bufnr].autoformat_enabled = false
      end
    end,
  },
  save_fn = function()
    if save_cmd ~= nil then
      vim.cmd(save_cmd)
    elseif silent then
      vim.cmd "silent! w"
    else
      vim.cmd "w"
    end
  end,
}
