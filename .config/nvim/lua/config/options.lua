-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim Defaults:

-- This section is automatically loaded by plugins.core

-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"
-- vim.g.autoformat = true
-- vim.g.snacks_animate = true
-- vim.g.lazyvim_picker = "auto"
-- vim.g.lazyvim_cmp = "auto"
-- vim.g.ai_cmp = true
-- vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
-- vim.g.root_lsp_ignore = { "copilot" }
-- vim.g.deprecation_warnings = false
-- vim.g.trouble_lualine = true
-- opt.autowrite = true -- Enable auto write
-- opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
-- opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
-- opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- opt.cursorline = true -- Enable highlighting of the current line
-- opt.expandtab = true -- Use spaces instead of tabs
-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
-- opt.foldlevel = 99
-- opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
-- opt.formatoptions = "jcroqlnt" -- tcqj
-- opt.grepformat = "%f:%l:%c:%m"
-- opt.grepprg = "rg --vimgrep"
-- opt.ignorecase = true -- Ignore case
-- opt.inccommand = "nosplit" -- preview incremental substitute
-- opt.jumpoptions = "view"
-- opt.laststatus = 3 -- global statusline
-- opt.linebreak = true -- Wrap lines at convenient points
-- opt.list = true -- Show some invisible characters (tabs...
-- opt.mouse = "a" -- Enable mouse mode
-- opt.number = true -- Print line number
-- opt.pumblend = 10 -- Popup blend
-- opt.pumheight = 10 -- Maximum number of entries in a popup
-- opt.relativenumber = true -- Relative line numbers
-- opt.ruler = false -- Disable the default ruler
-- opt.scrolloff = 4 -- Lines of context
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
-- opt.shiftround = true -- Round indent
-- opt.shiftwidth = 2 -- Size of an indent
-- opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- opt.showmode = false -- Dont show mode since we have a statusline
-- opt.sidescrolloff = 8 -- Columns of context
-- opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
-- opt.smartcase = true -- Don't ignore case with capitals
-- opt.smartindent = true -- Insert indents automatically
-- opt.spelllang = { "en" }
-- opt.splitbelow = true -- Put new windows below current
-- opt.splitkeep = "screen"
-- opt.splitright = true -- Put new windows right of current
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
-- opt.tabstop = 2 -- Number of spaces tabs count for
-- opt.termguicolors = true -- True color support
-- opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
-- opt.undofile = true
-- opt.undolevels = 10000
-- opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
-- opt.wildmode = "longest:full,full" -- Command-line completion mode
-- opt.winminwidth = 5 -- Minimum window width
-- opt.wrap = false -- Disable line wrap
--
-- if vim.fn.has("nvim-0.10") == 1 then
--   opt.smoothscroll = true
--   opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
--   opt.foldmethod = "expr"
--   opt.foldtext = ""
-- else
--   opt.foldmethod = "indent"
--   opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- end
-- vim.g.markdown_recommended_style = 0

local opt = vim.opt

-- Tab / Indentation

-- opt.tabstop = 2
-- opt.shiftwidth = 2
opt.softtabstop = 2
-- opt.expandtab = true
-- opt.smartindent = true
-- opt.wrap = true
-- opt.linebreak = true

-- Search

opt.incsearch = true
-- opt.ignorecase = true
-- opt.smartcase = true
opt.hlsearch = true

-- Appearance

opt.nu = true
-- opt.relativenumber = true
-- opt.termguicolors = true
opt.colorcolumn = "100"
-- opt.signcolumn = "yes"
opt.cmdheight = 1
-- opt.scrolloff = 10
-- opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour

opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/share/vim/undodir"
opt.backspace = "indent,eol,start"
-- opt.splitright = true
-- opt.splitbelow = true
opt.autochdir = true
opt.iskeyword:append("-")
-- opt.mouse:append("a")
-- opt.clipboard:append("unnamedplus")
opt.modifiable = true

-- Spelling

opt.spell = false
opt.encoding = "UTF-8"
opt.spelllang = "pt,en_us"

-- LSP Inline

vim.diagnostic.enable = true
vim.diagnostic.config({
  virtual_lines = false,
})

-- Auto LSP Pop Up

vim.o.updatetime = 500
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Folding

-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
-- opt.foldlevel = 99
-- opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
-- if vim.fn.has("nvim-0.10") == 1 then
--   opt.smoothscroll = true
--   opt.foldmethod = "expr"
--   opt.foldexpr = "nvim_treesitter#foldexpr()"
--   opt.foldtext = ""
-- else
--   opt.foldmethod = "indent"
--   opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- end
-- vim.g.markdown_recommended_style = 0

local function shorten_path(path)
  local shorten_if_more_than = 6 -- change this to 5, 7, etc
  -- Strip and remember the root ("/" or "~/")
  local prefix = ""
  if path:sub(1, 2) == "~/" then
    prefix = "~/"
    path = path:sub(3)
  elseif path:sub(1, 1) == "/" then
    prefix = "/"
    path = path:sub(2)
  end
  -- Split the remaining path into its components
  local parts = {}
  for part in string.gmatch(path, "[^/]+") do
    table.insert(parts, part)
  end
  -- Shorten only when there are more than shorten_if_more_than directories
  if #parts > shorten_if_more_than then
    local first = parts[1]
    local last_four = table.concat({
      parts[#parts - 3],
      parts[#parts - 2],
      parts[#parts - 1],
      parts[#parts],
    }, "/")
    return prefix .. first .. "/../" .. last_four
  end

  -- Re-attach the prefix when no shortening is needed
  return prefix .. table.concat(parts, "/")
end
-- Function to get the full path and replace the home directory with ~
local function get_winbar_path()
  local full_path = vim.fn.expand("%:p:h")
  return full_path:gsub(vim.fn.expand("$HOME"), "~")
end
-- Function to get the number of open buffers using the :ls command
local function get_buffer_count()
  return vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
end
-- Function to update the winbar
local function update_winbar()
  local home_replaced = get_winbar_path()
  local buffer_count = get_buffer_count()
  local display_path = shorten_path(home_replaced)
  vim.opt.winbar = "%#WinBar1#%m "
    .. "%#WinBar2#("
    .. buffer_count
    .. ") "
    -- this shows the filename on the left
    .. "%#WinBar3#"
    .. vim.fn.expand("%:t")
    -- This shows the file path on the right
    .. "%*%=%#WinBar1#"
    .. display_path
  -- I don't need the hostname as I have it in lualine
  -- .. vim.fn.systemlist("hostname")[1]
end
-- Winbar was not being updated after I left lazygit
vim.api.nvim_create_autocmd({ "BufEnter", "ModeChanged" }, {
  callback = function(args)
    local old_mode = args.event == "ModeChanged" and vim.v.event.old_mode or ""
    local new_mode = args.event == "ModeChanged" and vim.v.event.new_mode or ""
    -- Only update if ModeChanged is relevant (e.g., leaving LazyGit)
    if args.event == "ModeChanged" then
      -- Get buffer filetype
      local buf_ft = vim.bo.filetype
      -- Only update when leaving `snacks_terminal` (LazyGit)
      if buf_ft == "snacks_terminal" or old_mode:match("^t") or new_mode:match("^n") then
        update_winbar()
      end
    else
      update_winbar()
    end
  end,
})
