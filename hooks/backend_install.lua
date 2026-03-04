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

    -- Execute system brew to install the cask.
    -- We use "|| true" to succeed even if the cask is already installed
    -- (brew errors if the app already exists in /Applications).
    cmd.exec("brew install --cask " .. tool .. " || true")

    -- Create a tracking directory/file so mise knows this tool is "installed".
    cmd.exec("mkdir -p " .. install_path)
    cmd.exec("echo 'Installed via Homebrew Cask' > " .. install_path .. "/README.md")

    return {}
end
