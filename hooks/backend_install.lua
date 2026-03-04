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
    -- Count slashes: if 2 slashes, first two parts are the tap, last part is the cask
    local tap, cask_name
    local slash_count = select(2, tool:gsub("/", "/"))
    if slash_count >= 2 then
        -- e.g. "coder/coder/coder-desktop" → tap="coder/coder", cask="coder-desktop"
        tap = tool:match("^([^/]+/[^/]+)/")
        cask_name = tool:match("[^/]+$")
        -- Add the tap first (ignore error if already tapped)
        cmd.exec("bash -c 'brew tap " .. tap .. " 2>/dev/null || true'")
    else
        cask_name = tool
    end

    -- Check if already installed to avoid brew's non-zero exit on re-install
    local already_installed = pcall(function()
        cmd.exec("brew list --cask " .. cask_name)
    end)

    if not already_installed then
        -- Use bash -c so that the shell handles any exit code properly,
        -- and we catch errors at the Lua level with pcall.
        local ok, err = pcall(function()
            cmd.exec("bash -c 'brew install --cask " .. cask_name .. " 2>&1'")
        end)
        if not ok then
            -- Casks that are already installed report as an error from brew.
            -- Only propagate if it's not an "already installed" message.
            if not err:find("already installed") then
                error("Failed to install cask " .. cask_name .. ": " .. tostring(err))
            end
        end
    end

    -- Create a tracking directory so mise knows this tool is "installed".
    cmd.exec("mkdir -p " .. install_path)
    cmd.exec("bash -c 'echo \"Installed via Homebrew Cask\" > " .. install_path .. "/README.md'")

    return {}
end
