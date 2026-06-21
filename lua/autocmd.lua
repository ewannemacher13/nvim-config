local autocmd = vim.api.nvim_create_autocmd

-- '0#' in indentkeys causes '#' typed at the start of a line to reindent to
-- column 0 (via indentexpr). smartindent/cindent have the same behavior.
-- Override both per-buffer since filetype plugins run after set.lua.
autocmd("FileType", {
    desc = "disable # dedenting",
    pattern = "*",
    callback = function()
        vim.opt_local.smartindent = false
        vim.opt_local.indentkeys:remove("0#")
    end,
})

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
