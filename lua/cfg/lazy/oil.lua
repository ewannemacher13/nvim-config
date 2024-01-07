return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>")
        vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")

        require("oil").setup({
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            }
        })
    end
}
