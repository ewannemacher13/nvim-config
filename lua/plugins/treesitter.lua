return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                build = ":TSUpdate",
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup()
        end,
    },
}
