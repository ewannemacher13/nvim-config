return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "folke/lazydev.nvim" },
    --version = "1.*",
    build = "cargo build --release",

    opts = {
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            menu = { auto_show = true },
            documentation = { auto_show = true },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },
        fuzzy = { implementation = "prefer_rust" },
        signature = { enabled = true },
    },
}
