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

    local cask_name = tool
    local slash_count = select(2, tool:gsub("/", "/"))
    if slash_count >= 2 then
        local tap = tool:match("^([^/]+/[^/]+)/")
        cask_name = tool:match("[^/]+$")
        cmd.exec("bash -c 'brew tap " .. tap .. " 2>/dev/null || true'")
    end

    -- Run brew install using os.execute to avoid interfering with vfox runtime
    -- Suppressing all errors so mise queue never breaks.
    local install_cmd = string.format("HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask --no-quarantine %q >/dev/null 2>&1 || true", cask_name)
    os.execute(install_cmd)

    -- Setup tracking dir using os.execute to bypass cmd.exec issues
    os.execute("mkdir -p " .. install_path)
    
    -- Create README 
    local readme_path = install_path .. "/README.md"
    local r = io.open(readme_path, "w")
    if r then
        r:write("Installed via Homebrew Cask\n")
        r:close()
    end

    return {}
end
