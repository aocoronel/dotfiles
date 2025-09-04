local config = function()
  require("scissors").setup({
    snippetDir = "~/.config/nvim/snippets/",
    editSnippetPopup = {
      height = 0.4,
      width = 0.6,
      border = "rounded",
      keymaps = {
        cancel = "q",
        saveChanges = "<CR>",
        goBackToSearch = "<BS>",
        deleteSnippet = "<C-BS>",
        duplicateSnippet = "<C-d>",
        openInFile = "<C-o>",
        insertNextPlaceholder = "<C-p>",
        showHelp = "?",
      },
    },
    telescope = {
      alsoSearchSnippetBody = true,
      opts = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { width = 0.9 },
          preview_width = 0.6,
        },
      },
    },
    jsonFormatter = "jq",

    backdrop = {
      enabled = true,
      blend = 50,
    },
    icons = {
      scissors = "󰩫",
    },
  })
end

return {
  "chrisgrieser/nvim-scissors",
  dependencies = "nvim-telescope/telescope.nvim",
  lazy = true,
  config = config,
  opts = {
    snippetDir = "~/.config/nvim/snippets/",
  },
  cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
  keys = {
    {
      "<leader>ca",
      "<cmd>ScissorsAddNewSnippet<cr>",
      desc = "[S]nippet [A]dd",
    },
    {
      "<leader>ce",
      "<cmd>ScissorsEditSnippet<cr>",
      desc = "[S]nippet [E]dit",
    },
  },
}
