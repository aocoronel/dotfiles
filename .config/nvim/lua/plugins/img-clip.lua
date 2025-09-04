-- https://github.com/HakonHarnes/img-clip.nvim
-- Config Template From
-- https://github.com/linkarzu/github/dotfiles-latest/neovim/neobean/lua/plugins/img-clip.lua

return {
  "HakonHarnes/img-clip.nvim",
  cmd = { "PasteImage" },
  ft = { "markdown" },
  lazy = true,
  opts = {
    default = {
      use_absolute_path = false, ---@type boolean
      relative_to_current_file = true, ---@type boolean

      -- To align with my Obsidian Folder Structure, the paste directory..
      -- will be at the Embed folder if the current folder I'm in is Notes
      dir_path = function()
        local current_file = vim.fn.expand("%:p")
        if string.match(current_file, "/Notes/") then
          return "../Embed"
        else
          return "assets"
        end
      end,

      prompt_for_file_name = true, ---@type boolean
      file_name = "%y%m%d-%H%M%S", ---@type string

      extension = "avif", ---@type string
      process_cmd = "convert - -quality 75 avif:-", ---@type string

      -- extension = "webp", ---@type string
      -- process_cmd = "convert - -quality 75 webp:-", ---@type string

      -- extension = "png", ---@type string
      -- process_cmd = "convert - -quality 75 png:-", ---@type string

      -- extension = "jpg", ---@type string
      -- process_cmd = "convert - -quality 75 jpg:-", ---@type string
    },
    filetypes = {
      markdown = {
        url_encode_path = true, ---@type boolean
        template = "![$FILE_NAME]($FILE_PATH)", ---@type string
      },
    },
  },
  keys = {
    { "<leader>v", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
