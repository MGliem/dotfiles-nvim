require("nvim-treesitter.configs").setup {
  auto_install = true,
  highlight = { enable = true, disable = { "dockerfile" } },
  ensure_installed = {
    "vim",
    "lua",
    "luadoc",
    "bash",
    "json",
    "json5",
    "jq",
    "yaml",
    "java",
    "dockerfile",
    "regex",
    "toml",

    "gitcommit",
    "git_config",
    "diff",

    -- Markdown
    "markdown",
    "markdown_inline",

    "http",
    "xml",
    "graphql",

    -- Go Lang
    "go",
    "gomod",
    "gowork",
    "gosum",

    -- Web Dev
    "javascript",
    "typescript",
    "tsx",
    "html",
    "astro",
    "css",
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["sA"] = "@parameter.inner",
      },
    },
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = 1000,
    query = {
      "rainbow-parens",
      html = "rainbow-tags",
      javascript = "rainbow-tags-react",
      tsx = "rainbow-tags",
    },
  },
  tree_setter = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
  },
  indent = { enable = false }, --NOTE: This is an experimental feature(also create some lag on rapid keystorks).
}
