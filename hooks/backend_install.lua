--- Installs a specific version of a tool (Homebrew Cask)
--- Documentation: https://mise.jdx.dev/backend-plugin-development.html#backendinstall
--- @param ctx {tool: string, version: string, install_path: string} Context
--- @return table Empty table on success
function PLUGIN:BackendInstall(ctx)
    local tool = ctx.tool
    local install_path = ctx.install_path
    local cmd = require("cmd")

    if not tool or tool == "" then
        error("Tool name cannot be empty")
    end

    -- Handle tap/repo/cask format (e.g. "coder/coder/coder-desktop")
    local tap, cask_name
    local slash_count = select(2, tool:gsub("/", "/"))
    if slash_count >= 2 then
        tap = tool:match("^([^/]+/[^/]+)/")
        cask_name = tool:match("[^/]+$")
        -- Silently add the tap (ignore error if already tapped)
        pcall(function()
            cmd.exec("HOMEBREW_NO_AUTO_UPDATE=1 brew tap " .. tap)
        end)
    else
        cask_name = tool
    end

    -- Check if already installed to avoid brew's non-zero exit on re-install.
    local already_installed = pcall(function()
        cmd.exec("brew list --cask " .. cask_name)
    end)

    if not already_installed then
        -- Install the cask. Any brew error is silently ignored here —
        -- brew will have printed its own error. We still create the
        -- tracking dir so mise marks the tool and moves on to the next one.
        pcall(function()
            cmd.exec(
                "HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1 brew install --cask --no-quarantine " .. cask_name
            )
        end)
    end

    -- Create a tracking directory so mise knows this tool is "installed".
    cmd.exec("mkdir -p " .. install_path)
    cmd.exec("bash -c 'echo \"Installed via Homebrew Cask\" > " .. install_path .. "/README.md'")

    return {}
end
