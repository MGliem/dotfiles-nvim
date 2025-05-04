local glance = require "glance"

local filter = function(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local filterList = function(value)
  if value.uri then
    return not string.match(value.uri, "node_modules")
  elseif value.targetUri then
    return not string.match(value.targetUri, "node_modules")
  end
  return true
end

glance.setup {
  hooks = {
    before_open = function(results, open, jump, method)
      results = filter(results, filterList)
      if #results == 0 then
        vim.notify("No results.", vim.log.levels.INFO)
        return
      end
      open(results)
    end,
  },
}
