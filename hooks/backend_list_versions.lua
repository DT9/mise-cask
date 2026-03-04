local http = require("http")
local json = require("json")
local strings = require("strings")
local utils = require("utils")
-- hooks/backend_list_versions.lua
-- Lists available versions for a tool in this backend
-- Documentation: https://mise.jdx.dev/backend-plugin-development.html#backendlistversions
function PLUGIN:BackendListVersions(ctx)
    local tool = ctx.tool

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
    
    -- Casks are inherently different from formulae bottles. 
    -- We'll just return the stable version and handle the rest in Install.
    return { versions = { data.token .. "@" .. data.version } }
end
