local M = {}

M.override = {
  --   -- Cursor
  -- Cursor = { bg = "white", fg = "black2" },
  CursorLine = { bg = "#000000" },
  Visual = { bg = "#515151" },
  Comment = { fg = "#2d8f1d", italic = true },
  -- NvDashAscii = { fg = "purple", bg = "none" },
  IndentBlanklineContextStart = { bg = "none" },

  LspInlayHint = { fg = "#4e5665", bg = "NONE" },
  FloatBorder = { link = "TelescopeBorder" },

  CmpDoc = { bg = "black" },
  CmpDocBorder = { fg = "black", bg = "black" },
  --
  DiagnosticError = { bg = "none", fg = "#FF6363" },
  DiagnosticWarn = { bg = "none", fg = "#FA973A" },
  DiagnosticInfo = { bg = "none", fg = "#387EFF" },
  DiagnosticHint = { bg = "none", fg = "#16C53B" },
  --
  -- Diff
  DiffAdd = { bg = "#454545", fg = "#16C53B" },
  DiffDelete = { bg = "#454545", fg = "#FF6363" },
  DiffChange = { bg = "#454545", fg = "#FA973A" },
  DiffText = { bg = "#454545", fg = "#3982b0" },

  LspSignatureActiveParameter = { fg = "#FA973A" },
  --
  ["LineNrAbove"] = { fg = "#a25d09" },
  ["LineNrBelow"] = { fg = "#FA973A" },
  --   TelescopePromptNormal = { blend = 100 },
  --   -- TreeSitter highlights
  Repeat = { fg = "pink" },
  Include = { fg = "pink" },
  --   ["@definition"] = { underline = false },
  --   ["@boolean"] = { fg = "blue" },
  ["@comment"] = { link = "Comment" },
  --   ["@operator"] = { link = "Operator" },
  ["@constant"] = { fg = "blue" },
  --   ["@number.float"] = { link = "Float" },
  -- ["@modules"] = { fg = "white" },-
  ["Type"] = { fg = "#4EC8AF" },
  ["@type.builtin"] = { link = "Type" },
  ["@tag"] = { link = "Type" },
  --   ["@variable.go"] = { fg = "green" },
  ["@variable"] = { fg = "nord_blue" },
  ["@attribute"] = { link = "Constant" },
  ["@function.builtin"] = { fg = "cyan" },
  ["@function.method"] = { link = "Function" },
  ["@function.method.call"] = { link = "Function" },
  ["@function.call"] = { link = "Function" },
  ["@tag.builtin"] = { fg = "blue", bg = "NONE" },
  ["@tag.delimiter"] = { fg = "gray", bg = "NONE" },
  ["@tag.attribute"] = { fg = "#67d7f7", bg = "NONE" },
  --
  --   ["@function.call.go"] = { fg = "green" },
  ["@variable.member"] = { link = "@variable" },
  --   ["@constructor"] = { fg = "blue" },
  --
  ["Function"] = { fg = "yellow" },
  ["@function"] = { fg = "yellow" },
  --   ["@property"] = { fg = "blue" },
  --
  ["@keyword.import"] = { link = "Include" },
  --   ["@text.danger"] = { fg = "red" },
  --   ["@text.note"] = { fg = "blue" },
  --   ["@text.header"] = { bold = true },
  --   ["@text.diff.add"] = { fg = "green" },
  --   ["@text.diff.delete"] = { fg = "red" },
  --   ["@text.todo"] = { fg = "blue" },
  --   ["@string.special"] = { fg = "blue" },
  --   ["@class.css"] = { fg = "green" },
  --   ["@class.scss"] = { link = "@class.css" },
  --   ["@property.css"] = { fg = "teal" },
  --   ["@property.scss"] = { link = "@property.css" },
  --   ["@lsp.type.keyword"] = { link = "Keyword" },
  --   ["@lsp.type.operator"] = { fg = 'yellow' },
  --   ["@lsp.type.type"] = { fg = 'cyan' },
  --   ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  --   ["@lsp.type.property"] = { link = "@property" },
  --   ["@lsp.typemod.method.reference"] = { link = "Function" },
  --   ["@lsp.typemod.method.trait"] = { link = "Function" },
  --   ["@lsp.typemod.selfKeyword.defaultLibrary"] = { link = "Keyword" },

  -- -- Treesitter
  --    hl(0, '@error', { fg = c.vscRed, bg = 'NONE' }) -- Legacy
  --    hl(0, '@punctuation.bracket', { fg = c.vscFront, bg = 'NONE' })
  --    hl(0, '@punctuation.special', { fg = c.vscFront, bg = 'NONE' })
  --    hl(0, '@punctuation.delimiter', { fg = c.vscFront, bg = 'NONE' })
  --    hl(0, '@comment', { fg = c.vscGreen, bg = 'NONE', italic = opts.italic_comments })
  --    hl(0, '@comment.note', { fg = c.vscBlueGreen, bg = 'NONE', bold = true })
  --    hl(0, '@comment.warning', { fg = c.vscYellowOrange, bg = 'NONE', bold = true })
  --    hl(0, '@comment.error', { fg = c.vscRed, bg = 'NONE', bold = true })
  --    hl(0, '@constant', { fg = c.vscAccentBlue, bg = 'NONE' })
  --    hl(0, '@constant.builtin', { fg = c.vscBlue, bg = 'NONE' })
  --    hl(0, '@constant.macro', { fg = c.vscBlueGreen, bg = 'NONE' })
  --    hl(0, '@string.regexp', { fg = c.vscOrange, bg = 'NONE' })
  --    hl(0, '@string', { fg = c.vscOrange, bg = 'NONE' })
  --    hl(0, '@character', { fg = c.vscOrange, bg = 'NONE' })
  --    hl(0, '@number', { fg = c.vscLightGreen, bg = 'NONE' })
  --    hl(0, '@number.float', { fg = c.vscLightGreen, bg = 'NONE' })
  --    hl(0, '@boolean', { fg = c.vscBlue, bg = 'NONE' })
  --    hl(0, '@annotation', { fg = c.vscYellow, bg = 'NONE' })
  --    hl(0, '@attribute', { fg = c.vscYellow, bg = 'NONE' })
  --    hl(0, '@attribute.builtin', { fg = c.vscBlueGreen, bg = 'NONE' })
  --    hl(0, '@module', { fg = c.vscBlueGreen, bg = 'NONE' })
  --    hl(0, '@function', { fg = c.vscYellow, bg = 'NONE' })
  --    hl(0, '@function.builtin', { fg = c.vscYellow, bg = 'NONE' })
  --    hl(0, '@function.macro', { fg = c.vscYellow, bg = 'NONE' })
  --    hl(0, '@function.method', { fg = c.vscYellow, bg = 'NONE' })
  --    hl(0, '@variable', { fg = c.vscLightBlue, bg = 'NONE' })
  --    hl(0, '@variable.builtin', { fg = c.vscBlue, bg = 'NONE' })
  --    hl(0, '@variable.parameter', { fg = c.vscLightBlue, bg = 'NONE' })
  --    hl(0, '@variable.parameter.reference', { fg = c.vscLightBlue, bg = 'NONE' })
  --    hl(0, '@variable.member', { fg = c.vscLightBlue, bg = 'NONE' })
  --    hl(0, '@property', { fg = c.vscLightBlue, bg = 'NONE' })
  --    hl(0, '@constructor', { fg = c.vscBlue, bg = 'NONE' })
  --    hl(0, '@label', { fg = c.vscLightBlue, bg = 'NONE' })
  --    hl(0, '@keyword', { fg = c.vscBlue, bg = 'NONE' })
  --    hl(0, '@keyword.conditional', { fg = c.vscPink, bg = 'NONE' })
  --    hl(0, '@keyword.repeat', { fg = c.vscPink, bg = 'NONE' })
  --    hl(0, '@keyword.return', { fg = c.vscPink, bg = 'NONE' })
  --    hl(0, '@keyword.exception', { fg = c.vscPink, bg = 'NONE' })
  --    hl(0, '@keyword.import', { fg = c.vscPink, bg = 'NONE' })
  --    hl(0, '@operator', { fg = c.vscFront, bg = 'NONE' })
  --    hl(0, '@type', { fg = c.vscBlueGreen, bg = 'NONE' })
  --    hl(0, '@type.qualifier', { fg = c.vscBlue, bg = 'NONE' })
  --    hl(0, '@structure', { fg = c.vscLightBlue, bg = 'NONE' })
  --
  --    hl(0, '@text', { fg = c.vscFront, bg = 'NONE' }) -- Legacy
  --    hl(0, '@markup.strong', { fg = isDark and c.vscBlue or c.vscViolet, bold = true })
  --    hl(0, '@markup.italic', { fg = c.vscFront, bg = 'NONE', italic = true })
  --    hl(0, '@markup.underline', { fg = c.vscYellowOrange, bg = 'NONE', underline = true })
  --    hl(0, '@markup.strikethrough', { fg = c.vscFront, bg = 'NONE', strikethrough = true })
  --    hl(0, '@markup.heading', { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true })
  --    hl(0, '@markup.raw', { fg = c.vscFront, bg = 'NONE' })
  --    hl(0, '@markup.raw.markdown', { fg = c.vscOrange, bg = 'NONE' })
  --    hl(0, '@markup.raw.markdown_inline', { fg = c.vscOrange, bg = 'NONE' })
  --    hl(0, '@markup.link.label', { fg = c.vscLightBlue, bg = 'NONE', underline = opts.underline_links })
  --    hl(0, '@markup.link.url', { fg = c.vscFront, bg = 'NONE', underline = opts.underline_links })
  --    hl(0, '@markup.list.checked', { link = 'Todo' })
  --    hl(0, '@markup.list.unchecked', { link = 'Todo' })
  --    hl(0, '@textReference', { fg = isDark and c.vscOrange or c.vscYellowOrange })
  --    hl(0, '@stringEscape', { fg = isDark and c.vscOrange or c.vscYellowOrange, bold = true })
  --
  --    hl(0, '@diff.plus', { link = 'DiffAdd' })
  --    hl(0, '@diff.minus', { link = 'DiffDelete' })
  --    hl(0, '@diff.delta', { link = 'DiffChange' })
  --
  --    -- LSP semantic tokens
  --    hl(0, '@type.builtin', { link = '@type' })
  --    hl(0, '@lsp.typemod.type.defaultLibrary', { link = '@type.builtin' })
  --    hl(0, '@lsp.type.type', { link = '@type' })
  --    hl(0, '@lsp.type.typeParameter', { link = '@type' })
  --    hl(0, '@lsp.type.macro', { link = '@constant' })
  --    hl(0, '@lsp.type.enumMember', { link = '@constant' })
  --    hl(0, '@lsp.typemod.variable.readonly', { link = '@constant' })
  --    hl(0, '@lsp.typemod.property.readonly', { link = '@constant' })
  --    hl(0, '@lsp.typemod.variable.constant', { link = '@constant' })
  --    hl(0, '@lsp.type.member', { link = '@function' })
  --    hl(0, '@lsp.type.keyword', { link = '@keyword' })
  --    hl(0, '@lsp.typemod.keyword.controlFlow', { fg = c.vscPink, bg = 'NONE' })
  --    hl(0, '@lsp.type.comment.c', { fg = c.vscDimHighlight, bg = 'NONE' })
  --    hl(0, '@lsp.type.comment.cpp', { fg = c.vscDimHighlight, bg = 'NONE' })
  --    hl(0, '@event', { link = 'Identifier' })
  --    hl(0, '@interface', { link = 'Identifier' })
  --    hl(0, '@modifier', { link = 'Identifier' })
  --    hl(0, '@regexp', { fg = c.vscRed, bg = 'NONE' })
  --    hl(0, '@decorator', { link = 'Identifier' })

  -- Copilot
  CopilotSuggestion = { fg = "#83a598" },
  CopilotAnnotation = { fg = "#03a598" },
  --
  --   -- NvimTree
  --   NvimTreeGitNew = { fg = "green" },
  --   NvimTreeGitDirty = { fg = "yellow" },
  --   NvimTreeGitDeleted = { fg = "red" },
  --   NvimTreeCursorLine = { bg = "one_bg3" },
}

M.add = {

  DapStoppedLine = { link = "Visual" },

  -- LazyDimmed = { fg = colors.grey },

  EdgyWinBar = { bg = "black", fg = "white" },
  EdgyWinBarInactive = { bg = "black", fg = "white" },
  EdgyNormal = { bg = "black", fg = "white" },

  WinBar = { link = "Normal" },
  WinBarNC = { link = "Normal" },

  YankVisual = { fg = "black2", bg = "cyan" },

  MultiCursor = { bg = "white", fg = "black2" },
  MultiCursorMain = { bg = "white", fg = "black2" },

  DapBreakpoint = { fg = "red" },
  NvimDapVirtualText = { fg = "#6272A4" },

  LightBulbSign = { bg = "black", fg = "yellow" },

  NvimTreeOpenedFolderName = { fg = "purple", bold = true },
  NvimTreeOpenedFile = { fg = "green", bold = true },
  NvimTreeFileIcon = { fg = "purple" },

  CoverageCovered = { fg = "green" },
  CoverageUncovered = { fg = "red" },

  -- Cmp Highlights
  CmpItemKindCodeium = { fg = "green" },
  CmpItemKindTabNine = { fg = "pink" },
  CmpItemKindCopilot = { fg = "cyan" },

  PackageInfoOutdatedVersion = { fg = "red" },
  PackageInfoUpToDateVersion = { fg = "green" },

  VirtColumn = { fg = "black2" },
  FoldColumn = { bg = "black", fg = "white" },
  Folded = { bg = "black", fg = "white" },

  -- SpectreHeader
  -- SpectreBody
  -- SpectreFile
  -- SpectreDir
  -- SpectreSearch = { fg = "green" },
  -- SpectreBorder
  -- SpectreReplace

  ObsidianTodo = { fg = "red" },
  ObsidianDone = { fg = "green" },
  ObsidianRightArrow = { fg = "cyan" },
  ObsidianTilde = { fg = "cyan" },
  ObsidianBullet = { fg = "yellow" },
  ObsidianExtLinkIcon = { fg = "purple" },
  ObsidianRefText = { fg = "pink" },
  ObsidianHighlightText = { fg = "cyan" },
  ObsidianTag = { fg = "cyan" },

  -- Tree Sitter Rainbow
  RainbowDelimiterRed = { fg = "red" },
  RainbowDelimiterYellow = { fg = "yellow" },
  RainbowDelimiterBlue = { fg = "blue" },
  RainbowDelimiterOrange = { fg = "orange" },
  RainbowDelimiterGreen = { fg = "green" },
  RainbowDelimiterViolet = { fg = "purple" },
  RainbowDelimiterCyan = { fg = "cyan" },

  DiffviewDim1 = { fg = "grey" },
  DiffviewReference = { fg = "cyan" },
  DiffviewPrimary = { fg = "cyan" },
  DiffviewSecondary = { fg = "blue" },
  DiffviewNonText = { link = "DiffviewDim1" },
  DiffviewStatusUnmerged = { link = "GitMerge" },
  DiffviewStatusUntracked = { link = "GitNew" },
  DiffviewStatusModified = { link = "GitDirty" },
  DiffviewStatusRenamed = { link = "GitRenamed" },
  DiffviewStatusDeleted = { link = "GitDeleted" },
  DiffviewStatusAdded = { link = "GitStaged" },
  DiffviewFilePanelRootPath = { link = "NvimTreeRootFolder" },
  DiffviewFilePanelTitle = { link = "Title" },
  DiffviewFilePanelCounter = { fg = "cyan" },
  DiffviewFilePanelInsertions = { link = "GitNew" },
  DiffviewFilePanelDeletions = { link = "GitDeleted" },
  DiffviewFilePanelConflicts = { link = "GitMerge" },
  DiffviewFolderSign = { link = "NvimTreeFolderIcon" },
  DiffviewDiffDelete = { link = "Comment" },

  GitSignsChange = { fg = "green" },
  GitSignsAdd = { fg = "vibrant_green" },
  GitSignsDelete = { fg = "red" },
  GitSignsText = { fg = "white", bg = "red", bold = true },

  -- Deprecated
  cssDeprecated = { strikethrough = true },
  javaScriptDeprecated = { strikethrough = true },

  -- Search highlights
  HlSearchNear = { fg = "#2E3440", bg = "yellow" },
  HlSearchLens = { fg = "#2E3440", bg = "blue" },
  HlSearchLensNear = { fg = "#2E3440", bg = "yellow" },

  -- LSP Saga
  SagaBorder = { fg = "blue" },
  SagaFolder = { fg = "cyan" },
  HoverNormal = { fg = "white" },
  CodeActionText = { fg = "white" },
  CodeActionNumber = { link = "Number" },

  -- Custom highlights
  CopilotHl = { fg = "white", bg = "statusline_bg" },
  RecordHl = { fg = "red", bg = "statusline_bg" },
  CmpHl = { fg = "red", bg = "statusline_bg" },
  NotificationHl = { fg = "white", bg = "statusline_bg" },
  TermHl = { fg = "green", bg = "statusline_bg" },
  SplitHl = { fg = "white", bg = "black2" },
  HarpoonHl = { fg = "white", bg = "black2" },

  -- Blankline
  IndentBlanklineContextChar = { fg = "none" },
  IndentBlanklineContextStart = { bg = "none" },

  DiagnosticUnnecessary = { link = "", fg = "light_grey" },
  LspInlayHint = { link = "", fg = "light_grey" },

  -- Noice
  NoiceCursor = { link = "Cursor" },
  NoiceCmdlinePopupBorder = { fg = "cyan" },
  NoiceCmdlinePopupBorderSearch = { fg = "yellow" },
  NoiceCmdlinePopup = { fg = "cyan" },
  NoiceConfirm = { fg = "cyan" },
  NoiceConfirmBorder = { fg = "cyan" },
  NoicePopup = { fg = "cyan" },
  NoicePopupBorder = { fg = "cyan" },
  NoicePopupmenu = { fg = "cyan" },

  HarpoonBorder = { fg = "cyan" },
}

return M
