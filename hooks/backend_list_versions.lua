--- Lists available versions for a tool in this backend
--- Documentation: https://mise.jdx.dev/backend-plugin-development.html#backendlistversions
--- @param ctx {tool: string} Context (tool = the tool name requested)
--- @return {versions: string[]} Table containing list of available versions
function PLUGIN:BackendListVersions(ctx)
    local tool = ctx.tool
    local http = require("http")
    local json = require("json")

    if not tool or tool == "" then
        error("Tool name cannot be empty")
    end

    local resp, err = http.get({
        url = "https://formulae.brew.sh/api/cask/" .. tool .. ".json",
    })

    if err then
        error("Failed to fetch versions for " .. tool .. ": " .. err)
    end

    if resp.status_code ~= 200 then
        error("API returned status " .. resp.status_code .. " for " .. tool)
    end

    local data = json.decode(resp.body)

    -- Casks only have one "latest" version available via the API.
    -- Return ONLY the version string.
    return { versions = { data.version } }
end
