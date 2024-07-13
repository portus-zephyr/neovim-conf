---@type LazySpec[]
return {
    -- Add C/C++ to treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "c", "cpp" })
            end
        end,
    },
    {
        "p00f/clangd_extensions.nvim",
        config = function() end,
        opts = {
            inlay_hints = {
                inline = false,
            },
            ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                    type = "",
                    declaration = "",
                    expression = "",
                    specifier = "",
                    statement = "",
                    ["template argument"] = "",
                },
                kind_icons = {
                    Compound = "",
                    Recovery = "",
                    TranslationUnit = "",
                    PackExpansion = "",
                    TemplateTypeParm = "",
                    TemplateTemplateParm = "",
                    TemplateParamObject = "",
                },
            },
        },
    },
    -- Correctly setup lspconfig for clangd 🚀
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Ensure mason installs the server
                clangd = {
                    keys = {
                        {
                            "<leader>cR",
                            "<cmd>ClangdSwitchSourceHeader<cr>",
                            desc = "Switch Source/Header (C/C++)",
                        },
                    },
                    root_dir = function(fname)
                        return require("lspconfig.util").root_pattern(
                            "Makefile",
                            "configure.ac",
                            "configure.in",
                            "config.h.in",
                            "meson.build",
                            "meson_options.txt",
                            "build.ninja"
                        )(fname) or require(
                            "lspconfig.util"
                        ).root_pattern(
                            "compile_commands.json",
                            "compile_flags.txt"
                        )(fname) or require(
                            "lspconfig.util"
                        ).find_git_ancestor(fname)
                    end,
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
            },
            setup = {
                clangd = function(_, opts)
                    local clangd_ext_opts =
                        require("lazyvim.util").opts "clangd_extensions.nvim"
                    require("clangd_extensions").setup(
                        vim.tbl_deep_extend(
                            "force",
                            clangd_ext_opts or {},
                            { server = opts }
                        )
                    )
                    return false
                end,
            },
        },
    },
    {
        "nvim-cmp",
        opts = function(_, opts)
            table.insert(
                opts.sorting.comparators,
                1,
                require "clangd_extensions.cmp_scores"
            )
        end,
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local dap = require "dap"
            for _, lang in ipairs { "c", "cpp" } do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        name = "Launch file",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.input {
                                input = "Path to executable: ",
                                text = vim.fn.getcwd() .. "/",
                                completion = "file",
                            }
                        end,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                        args = {},
                        env = {
                            UBSAN_OPTIONS = "print_stacktrace=1",
                            ASAN_OPTIONS = "abort_on_error=1:fast_unwind_on_malloc=0:detect_leaks=0",
                        },
                    },
                }
            end
        end,
    },
}
