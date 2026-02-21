return {
    'lervag/vimtex',
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = 'sioyek'
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "out", -- or "/absolute/path/to/temp"
        }
    end,
}
