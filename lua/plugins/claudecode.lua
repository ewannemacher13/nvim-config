return {
    "coder/claudecode.nvim",
    config = function()
        require("claudecode").setup({
            -- Use Neovim's built-in terminal instead of requiring snacks.nvim.
            terminal = {
                provider = "native",
                split_side = "right",
                split_width_percentage = 0.35,
            },
        })
    end,
    keys = {
        -- Open / focus the Claude terminal. With Claude open, it already sees
        -- your active buffer and cursor selection via the IDE integration, so
        -- you can just ask "what does this do?" about the current file.
        { "<leader>ic", "<cmd>ClaudeCode<cr>",       desc = "Toggle Claude Code" },
        { "<leader>if", "<cmd>ClaudeCodeFocus<cr>",  desc = "Focus Claude Code" },

        -- Ask about a visual selection: select in visual mode, then send it.
        { "<leader>iv", "<cmd>ClaudeCodeSend<cr>",   mode = "v", desc = "Send selection to Claude" },

        -- Explicitly add the current file to Claude's context.
        { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>",  desc = "Add current buffer to Claude" },
        -- Add the file under the cursor from an Oil buffer.
        { "<leader>iv", "<cmd>ClaudeCodeTreeAdd<cr>", ft = "oil", desc = "Add file to Claude" },

        -- Accept / reject a diff Claude proposes.
        { "<leader>iy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
        { "<leader>in", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Reject Claude diff" },
    },
}
