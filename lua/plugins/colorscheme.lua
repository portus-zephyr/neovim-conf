---@type LazySpec[]
return {
    { "folke/tokyonight.nvim", enabled = false },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            flavour = "mocha",
            transparent_background = true,
            integrations = {
                alpha = false,
                neogit = false,
                nvimtree = false,
                telescope = { enabled = false },

                harpoon = true,
                lsp_trouble = true,
                mason = true,
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                which_key = true,
            },
            custom_highlights = function(colors)
                return {
                    LineNrAbove = { fg = colors.subtext0 },
                    LineNrBelow = { fg = colors.subtext0 },
                    CursorLineNr = { fg = colors.peach, style = { "bold" } },
                }
            end,
        },
    },
}
