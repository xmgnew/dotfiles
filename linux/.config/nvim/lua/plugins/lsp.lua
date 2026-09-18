return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                sqls = {
                    -- This function runs when sqls connects to a SQL file
                    on_attach = function(client, bufnr)
                        -- Completely disable sqls from trying to format your code
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                },
            },
        },
    },
}
