return {
    "laytan/cloak.nvim",
    config = function()
        require("cloak").setup({
            enabled = true,
            cloak_character = "*",
            highlight_group = "Comment",
            cloak_on_leave = true,
            patterns = {
                {
                    file_pattern = {
                        "*.env*",
                        "wrangler.toml",
                        ".dev.vars",
                    },
                    cloak_pattern = "=.+",
                },
            },
        })
    end,
}
