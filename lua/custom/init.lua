local term = require("custom.plugins.terminal")

vim.keymap.set("n", "<A-i>", function()
    term.gotoTerminal(1)
end)
vim.keymap.set("n", "<A-o>", function()
    term.gotoTerminal(2)
end)

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
    callback = function(args)
        if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
        end
    end,
})
