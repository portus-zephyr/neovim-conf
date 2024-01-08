---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.dap.core" },
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<F5>",
                function() require("dap").continue() end,
                desc = "Debugger: Start",
            },
            {
                "<F17>",
                function() require("dap").terminate() end,
                desc = "Debugger: Stop",
            }, -- Shift+F5
            {
                "<F29>",
                function() require("dap").restart_frame() end,
                desc = "Debugger: Restart",
            }, -- Control+F5
            {
                "<F6>",
                function() require("dap").pause() end,
                desc = "Debugger: Pause",
            },
            {
                "<F9>",
                function() require("dap").toggle_breakpoint() end,
                desc = "Debugger: Toggle Breakpoint",
            },
            {
                "<F10>",
                function() require("dap").step_over() end,
                desc = "Debugger: Step Over",
            },
            {
                "<F11>",
                function() require("dap").step_into() end,
                desc = "Debugger: Step Into",
            },
            {
                "<F23>",
                function() require("dap").step_out() end,
                desc = "Debugger: Step Out",
            }, -- Shift+F11
        },
    },
}
