# mise-cask

A backend plugin for [mise](https://github.com/jdx/mise) to manage Homebrew Casks.

## Features
- **Modern Backend**: Built using the native `mise` Lua backend API.
- **System Integration**: Leverages your system's `brew` command to install macOS applications.
- **Unified Config**: Allows you to manage your CLI tools and GUI applications in a single `config.toml`.

## Usage

### 1. Installation

Install the plugin via its URL:

```bash
mise plugin install cask https://github.com/DT9/mise-cask
```

### 2. Configure tools

Add your favorite Casks to your `mise` configuration:

```toml
[tools]
"cask:alt-tab" = "latest"
"cask:raycast" = "latest"
"cask:visual-studio-code" = "latest"
```

### 3. Install

```bash
mise install
```

## How it works
This plugin acts as a bridge. When you run `mise install cask:app`, it:
1. Queries the Homebrew API for the latest version.
2. Executes `brew install --cask app`.
3. Creates a tracking file in `~/.local/share/mise/installs/cask-app/latest` so `mise` knows it is installed.

## License
MIT
