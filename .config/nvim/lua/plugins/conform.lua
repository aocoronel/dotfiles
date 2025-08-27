return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  cmd = "ConformInfo",
  ft = { "lua", "shell", "python", "javascript", "typescript", "json", "html", "css", "markdown", "rust", "toml" },
  enabled = true,
  lazy = true,
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang-format" },
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nim = { "nph" },
        nix = { "alejandra" },
        python = { "black" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = { "prettier" },
        zsh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        nph = {
          command = "nph",
          stdin = false,
          args = { "$FILENAME" },
        },
      },
    }
    return opts
  end,
}
