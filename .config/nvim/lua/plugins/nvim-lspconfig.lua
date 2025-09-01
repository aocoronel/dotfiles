-- Linters

-- "black",
-- "fixjson",
-- "prettier",
-- "prettierd",
-- "rustfmt",
-- "shfmt",
-- "stylua",

local config = function()
  local lspconfig = require("lspconfig")

  -- lua
  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
          },
        },
      },
    },
  })

  -- Nim
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  lspconfig.nim_langserver.setup({
    cmd = { "nimlangserver" },
    filetypes = { "nim" },

    root_dir = function(fname)
      if fname:find("%.nimble/") then
        return nil
      end

      return util.root_pattern("*.nimble")(fname) or util.find_git_ancestor(fname)
    end,

    on_attach = function(client, bufnr)
      local filename = vim.api.nvim_buf_get_name(bufnr)
      if filename:find("%.nimble/") then
        vim.schedule(function()
          vim.lsp.stop_client(client.id)
        end)
      end
    end,
  })
  -- lspconfig.nimls.setup({
  --   cmd = { "nimlsp" },
  --   filetypes = { "nim" },
  -- })

  -- Nix
  lspconfig.nil_ls.setup({
    cmd = { "nil" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
  })

  -- json
  lspconfig.jsonls.setup({
    filetypes = { "json", "jsonc" },
    init_options = {
      provideFormatter = true,
    },
  })

  -- python
  lspconfig.pyright.setup({
    settings = {
      pyright = {
        disableOrganizeImports = false,
        analysis = {
          useLibraryCodeForTypes = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          autoImportCompletions = true,
        },
      },
    },
  })

  -- golang
  lspconfig.gopls.setup({
    filetypes = {
      "go",
      "gomod",
      "gowork",
      "gotmpl",
    },
  })

  -- typescript
  lspconfig.ts_ls.setup({
    filetypes = {
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
    },
    commands = {},
    settings = {
      typescript = {
        indentStyle = "space",
        indentSize = 2,
      },
    },
  })

  -- bash
  lspconfig.bashls.setup({
    filetypes = { "sh", "aliasrc" },
    settings = {
      bashIde = {
        globPattern = "*@(.sh|.inc|.bash|.command)",
      },
    },
  })

  -- markdown
  require("lspconfig").marksman.setup({
    filetypes = { "markdown", "markdown.mdx" },
  })
  require("lspconfig").markdown_oxide.setup({
    filetypes = { "markdown" },
  })

  -- rust
  require("lspconfig").bacon_ls.setup({
    filetypes = { "rust" },
  })

  -- typescriptreact, javascriptreact, css, sass, scss, less, svelte, vue
  lspconfig.emmet_ls.setup({
    filetypes = {
      "typescriptreact",
      "javascriptreact",
      "javascript",
      "css",
      "sass",
      "scss",
      "less",
      "svelte",
      "vue",
      "html",
    },
  })

  -- docker
  lspconfig.dockerls.setup({})

  -- C/C++
  lspconfig.clangd.setup({
    cmd = {
      "clangd",
      "--offset-encoding=utf-16",
    },
  })

  local prettier_d = require("efmls-configs.formatters.prettier_d")
  local luacheck = require("efmls-configs.linters.luacheck")
  local stylua = require("efmls-configs.formatters.stylua")
  local flake8 = require("efmls-configs.linters.flake8")
  local black = require("efmls-configs.formatters.black")
  local eslint = require("efmls-configs.linters.eslint")
  local fixjson = require("efmls-configs.formatters.fixjson")
  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")
  local hadolint = require("efmls-configs.linters.hadolint")
  local cpplint = require("efmls-configs.linters.cpplint")
  local clangformat = require("efmls-configs.formatters.clang_format")

  -- configure efm server
  lspconfig.efm.setup({
    filetypes = {
      "lua",
      "python",
      "json",
      "jsonc",
      "sh",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "svelte",
      "vue",
      "docker",
      "html",
      "css",
      "c",
      "cpp",
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
    settings = {
      languages = {
        lua = { luacheck, stylua },
        python = { flake8, black },
        typescript = { eslint, prettier_d },
        json = { eslint, fixjson },
        jsonc = { eslint, fixjson },
        sh = { shellcheck, shfmt },
        javascript = { eslint, prettier_d },
        javascriptreact = { eslint, prettier_d },
        typescriptreact = { eslint, prettier_d },
        svelte = { eslint, prettier_d },
        vue = { eslint, prettier_d },
        docker = { hadolint, prettier_d },
        html = { prettier_d },
        css = { prettier_d },
        c = { clangformat, cpplint },
        cpp = { clangformat, cpplint },
      },
    },
  })
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  event = "BufReadPre",
  lazy = true,
  dependencies = {
    "williamboman/mason.nvim",
    "creativenull/efmls-configs-nvim",
  },
  opts = {
    servers = {
      marksman = {
        cmd = {
          "sh",
          "-c",
          "test -x /run/current-system/sw/bin/marksman && { /run/current-system/sw/bin/marksman server; } || { marksman server; }",
        },
      },
      markdown_oxide = {
        cmd = {
          "sh",
          "-c",
          "test -x /run/current-system/sw/bin/markdown-oxide && { /run/current-system/sw/bin/markdown-oxide server; } || { markdown-oxide server; }",
        },
      },
    },
  },
}
