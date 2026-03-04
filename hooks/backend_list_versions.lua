--- Lists available versions for a tool in this backend
--- Documentation: https://mise.jdx.dev/backend-plugin-development.html#backendlistversions
--- @param ctx {tool: string} Context (tool = the tool name requested)
--- @return {versions: string[]} Table containing list of available versions
function PLUGIN:BackendListVersions(ctx)
    local tool = ctx.tool

    if not tool or tool == "" then
        error("Tool name cannot be empty")
    end

    -- Homebrew casks only have one active version at any given time.
    -- Return "latest" immediately (no HTTP call) so mise can resolve all
    -- casks in parallel without waiting for 20+ sequential API requests.
    -- The real version is captured during BackendInstall via `brew info`.
    return { versions = { "latest" } }
end
