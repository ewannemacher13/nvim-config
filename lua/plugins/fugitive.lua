return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set('n', '<leader>gs', function()
            local splitbelow = vim.o.splitbelow
            vim.o.splitbelow = false
            vim.cmd.Git()
            vim.o.splitbelow = splitbelow
        end)
    end,
}
