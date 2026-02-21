-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "checktime",
})

vim.opt.wrap = true
vim.opt.linebreak = true -- Wrap at word boundaries rather than in the middle of a word
vim.opt.textwidth = 0    -- Ensure textwidth does not interfere with visual wrapping

