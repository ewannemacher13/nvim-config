return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
            },

            formatters = {
                stylua = {
                    inherit = false,
                    args = { "--indent-type", "Spaces", "$FILENAME", "-" },
                },
            },
        })

        vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ async = true, lsp_format = "fallback" })
        end)
    end,
}
