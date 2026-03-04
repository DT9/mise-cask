-- metadata.lua
-- Backend plugin metadata and configuration
-- Documentation: https://mise.jdx.dev/backend-plugin-development.html

PLUGIN = { -- luacheck: ignore
    -- Required: Plugin name (will be the backend name users reference)
    name = "cask",

    -- Required: Plugin version (not the tool versions)
    version = "1.0.0",

    -- Required: Brief description of the backend and tools it manages
    description = "Homebrew Cask backend for mise",

    -- Required: Plugin author/maintainer
    author = "DT9",

    -- Optional: Plugin homepage/repository URL
    homepage = "https://github.com/DT9/mise-cask",

    -- Optional: Plugin license
    license = "MIT",

    -- Optional: Important notes for users
    notes = {
        "Requires Homebrew (brew) to be installed on your system.",
        "Windows is not supported as Homebrew does not support it.",
    },
}
