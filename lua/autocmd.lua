local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
    desc = "highlight on yank",
    callback = function()
        vim.hl.on_yank({
            timeout = 40,
        })
    end,
})

autocmd("BufWritePre", {
    desc = "remove trailing whitespace",
    command = [[%s/\s\+$//e]],
})

-- autocmd("FileType", {
--     desc = "disable comment continuation on new line",
--     callback = function()
--         vim.opt.formatoptions:remove({ "c", "r", "o" })
--     end,
-- })
