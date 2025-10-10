---
description: Copy global MCP config into the homedir config.
---

# Copy MCP command

There are two files used for configuring MCP servers.

1. `~/.claude/settings.json` which is the source of truth.
2. `~/.claude.json` which should be a mirror of the settings.json file.

This command should copy all defined MCP servers from the settings.json file and
replace all existing MCP servers defined in the .claude.json file.
