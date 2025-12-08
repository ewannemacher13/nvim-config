local M = {}
local terminals = {}

local function create_terminal()
    vim.cmd.term()
    local buf_id = vim.api.nvim_get_current_buf()
    local channel_id = vim.bo.channel

    return buf_id, channel_id
end

local function find_terminal(args)
    if type(args) == "number" then
        args = { idx = args }
    end

    local term_handle = terminals[args.idx]

    if not term_handle or not vim.api.nvim_buf_is_valid(term_handle.buf_id) then
        local buf_id, channel_id = create_terminal()

        term_handle = {
            buf_id = buf_id,
            channel_id = channel_id,
        }

        terminals[args.idx] = term_handle
    end

    return term_handle
end

function M.gotoTerminal(idx)
    local term_handle = find_terminal(idx)

    vim.api.nvim_set_current_buf(term_handle.buf_id)
end

return M
