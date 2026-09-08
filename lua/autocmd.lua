local autocmd = vim.api.nvim_create_autocmd

-- '0#' in indentkeys causes '#' typed at the start of a line to reindent to
-- column 0 (via indentexpr). smartindent/cindent have the same behavior.
-- The c/r/o formatoptions flags auto-continue comments on newline (r/o) and
-- auto-wrap them (c). All of these get re-set by filetype plugins, which run
-- after set.lua, so override them per-buffer here too.
autocmd("FileType", {
    desc = "disable # dedenting and comment continuation",
    pattern = "*",
    callback = function()
        vim.opt_local.smartindent = false
        vim.opt_local.indentkeys:remove("0#")
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
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
