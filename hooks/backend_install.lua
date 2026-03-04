local http = require("http")
local json = require("json")
local cmd = require("cmd")
local utils = require("utils")
-- hooks/backend_install.lua
-- Installs a specific version of a tool
-- Documentation: https://mise.jdx.dev/backend-plugin-development.html#backendinstall

function PLUGIN:BackendInstall(ctx)
    local tool = ctx.tool
    local version = ctx.version
    local install_path = ctx.install_path

    if not tool or tool == "" then
        error("Tool name cannot be empty")
    end

    utils.log("Installing " .. tool .. " via brew install --cask")
    
    -- Execute system brew install
    -- We append "|| true" to ignore errors if the app already exists or is already installed.
    cmd.exec("brew install --cask " .. tool .. " || true")
    
    -- Create installation directory for mise to track
    cmd.exec("mkdir -p " .. install_path)
    
    -- Create a dummy file so mise knows it's installed
    cmd.exec("echo 'Installed via Homebrew Cask' > " .. install_path .. "/README.md")
    
    return {}
end
