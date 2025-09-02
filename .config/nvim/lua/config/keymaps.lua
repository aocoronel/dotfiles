-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- More keymaps can be found at ~/.config/nvim/lua/scripts/

local keymap = vim.keymap

-- Toggle Spelling

keymap.set("n", "<leader>ts", ":set spell!<CR>", { noremap = true, silent = true, desc = "Toggle: [S]pell" })

-- Managing files

keymap.set("n", "<M-h>", ":cnext<CR>", { desc = "Next QuickFix" })
keymap.set("n", "<M-l>", ":cprev<CR>", { desc = "Previous QuickFix" })

-- File Permissions

keymap.set("n", "<leader>cx", ":!chmod +x %<cr>", { desc = "Make Executable" })

-- Search and Replace

keymap.set("v", "<leader>ss", ":s/", { desc = "Search & Replace" })
keymap.set("n", "<leader>ss", ":%s/", { desc = "Search & Replace" })

-- Sort

keymap.set("v", "<leader>sS", ":!sort<CR>", { desc = "Sort" })

-- Managing lines

keymap.set("i", "<Tab>", "<C-o>>>", { noremap = true, silent = true })
keymap.set("i", "<S-Tab>", "<C-o><<", { noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true }) -- Shift + K in Visual Mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true }) -- Shift + J in Visual Mode

-- Motion

keymap.set("n", "<C-u>", "<C-u>zz") -- Page Up and Center
keymap.set("n", "<C-d>", "<C-d>zz") -- Page Down and Center

keymap.set("n", "n", "nzzzv") -- Next and Center
keymap.set("n", "N", "Nzzzv") -- Previous and Center

-- Visual

keymap.set("n", "<leader>h", ":noh<cr>") -- Remove highlight

-- Panes

keymap.set("n", "<C-h>", "<C-w>h") -- Navigate Left
keymap.set("n", "<C-j>", "<C-w>j") -- Navigate Down
keymap.set("n", "<C-k>", "<C-w>k") -- Navigate Up
keymap.set("n", "<C-l>", "<C-w>l") -- Navigate Right
keymap.set("n", "<C-h>", "TmuxNavigateLeft") -- Navigate Left
keymap.set("n", "<C-j>", "TmuxNavigateDown") -- Navigate Down
keymap.set("n", "<C-k>", "TmuxNavigateUp") -- Navigate Up
keymap.set("n", "<C-l>", "TmuxNavigateRight") -- Navigate Right
keymap.set("n", "<leader>mz", ":Maximize<CR>") -- Maximize current pane

-- Buffers

keymap.set("n", "<M-n>", ":BufferLineCycleNext<CR>") -- Next Buffer
keymap.set("n", "<M-p>", ":BufferLineCyclePrev<CR>") -- Previous Buffer

keymap.set("n", "<M-1>", ":BufferLineGoToBuffer 1<CR>") -- Move to Buffer
keymap.set("n", "<M-2>", ":BufferLineGoToBuffer 2<CR>") -- Move to Buffer
keymap.set("n", "<M-3>", ":BufferLineGoToBuffer 3<CR>") -- Move to Buffer
keymap.set("n", "<M-4>", ":BufferLineGoToBuffer 4<CR>") -- Move to Buffer
keymap.set("n", "<M-5>", ":BufferLineGoToBuffer 5<CR>") -- Move to Buffer
keymap.set("n", "<M-6>", ":BufferLineGoToBuffer 6<CR>") -- Move to Buffer
keymap.set("n", "<M-7>", ":BufferLineGoToBuffer 7<CR>") -- Move to Buffer
keymap.set("n", "<M-8>", ":BufferLineGoToBuffer 8<CR>") -- Move to Buffer
keymap.set("n", "<M-9>", ":BufferLineGoToBuffer 9<CR>") -- Move to Buffer

-- Indenting

keymap.set("v", "<", "<gv") -- Allows multiple indents without losing cursor
keymap.set("v", ">", ">gv") -- Allows multiple indents without losing cursor

-- URL

keymap.set("n", "<leader>gx", ":!xdg-open <c-r><c-a>", { desc = "Follow URL" })

-- LSP

keymap.set("n", "<leader>fmd", vim.lsp.buf.format, { desc = "[L]SP Format" })

-- Plugins

keymap.set("n", "<leader>cc", ":CsvViewToggle display_mode=border header_lnum=1", { desc = "[C]SV View" })

-- Zoxide

-- keymap.set("n", "<leader>gz", ":FzfLua zoxide<CR>", { desc = "[Z]oxide" })

-- Footnotes

-- keymap.set("n", "<leader>fmf", ":lua require('footnote').organize_footnotes()<CR>", { desc = "[F]ootnote Organize" })

-- Obsidian

-- keymap.set("n", "<leader>oq", ":ObsidianQuickSwitch<cr>", { desc = "[Q]uick Switch" })
-- keymap.set("n", "<leader>ow", ":ObsidianWorkspace<cr>", { desc = "[W]orkspace" })
-- keymap.set("n", "<leader>or", ":ObsidianRename<cr>", { desc = "[R]ename" })
-- keymap.set("n", "<leader>os", ":ObsidianSearch<cr>", { desc = "[S]earch" })
-- keymap.set("n", "<leader>oc", ":ObsidianTOC<cr>", { desc = "To[C]" })
-- keymap.set("n", "<leader>om", ":ObsidianTags<cr>", { desc = "[M]arks" })
-- keymap.set("n", "<leader>ot", ":ObsidianTemplate<cr>", { desc = "[T]emplate" })
-- keymap.set("n", "<leader>dd", ":ObsidianToday<cr>", { desc = "[D]aily Note" })

-- Links

-- keymap.set("n", "<leader>ol", "viw:ObsidianLink<cr>", { desc = "[L]ink" }) -- Link under cursor
-- keymap.set("v", "<leader>oL", ":ObsidianLink<cr>", { desc = "[L]ink" }) -- Link in visual mode
--
-- keymap.set("n", "<leader>ob", ":ObsidianBacklinks<cr>", { desc = "[B]acklinks" })
--
-- keymap.set("n", "<leader>oB", ":ObsidianLinks<cr>", { desc = "Coming Links" })

-- Others

-- keymap.set("n", "<leader>oz", ":ObsidianCheck<cr>", { desc = "Check plugin" })
