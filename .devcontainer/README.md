# Unison Carbon Pipeline - Dev Container

This directory contains the development container configuration for the Unison Carbon Pipeline project.

## Overview

The dev container is based on **Chainguard's Node.js development image** (`cgr.dev/chainguard/node:latest-dev`), which provides:
- Minimal attack surface with secure-by-default container images
- Regular security updates (rebuilt nightly)
- Node.js and npm pre-installed and optimized
- Shell and APK package manager for installing additional tools

## What's Included

### Base Image
- **Chainguard Node.js (latest-dev)**: Secure, minimal Node.js development environment built on Wolfi

### Installed Tools
- **Node.js and npm** (pre-installed in base image)
- Bash shell (pre-installed in base image)
- curl (for downloading dependencies)
- tar (for extracting archives)
- git (for version control)
- ca-certificates (for secure HTTPS connections)
- **Unison UCM** (Unison Codebase Manager) - latest version
- **Claude Code CLI** - AI-powered coding assistant
- **Beads (bd)** - AI-assisted development CLI tool

### Port Forwarding
- **Port 5757**: UCM communication
- **Port 8080**: Unison UI (accessible at http://localhost:8080/public/ui/)
- **Port 5858**: UCM MCP Server (HTTP endpoint for AI agents)

## Usage

### Opening in VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open this project in VS Code
3. Press `F1` and select "Dev Containers: Reopen in Container"

### Manual Docker Build

```bash
cd .devcontainer
docker build -t unison-carbon-pipeline-dev .
docker run -it --rm \
  -v $(pwd)/..:/workspace \
  -v $(pwd)/../.unison:/root/.unison \
  -v $(pwd)/../.claude:/root/.claude \
  -p 5757:5757 \
  -p 8080:8080 \
  -p 5858:5858 \
  unison-carbon-pipeline-dev
```

### Starting UCM

Once inside the container:

```bash
ucm
```

### Starting the UCM MCP Server

The Unison Codebase Manager includes a built-in MCP (Model Context Protocol) server that enables AI agents to interact with your Unison codebase. There are two ways to use it:

#### Option 1: stdio Connection (Recommended)

This is the recommended approach for connecting AI agents like Claude to UCM:

```bash
# The MCP server can be started with:
ucm mcp
```

For Claude Desktop or other MCP clients, use the configuration in `mcp-config.json`:

```json
{
  "mcpServers": {
    "unison": {
      "command": "/usr/local/bin/ucm",
      "args": ["mcp"]
    }
  }
}
```

#### Option 2: Convenience Script

Use the provided startup script:

```bash
start-mcp-server
```

#### Option 3: HTTP Endpoint (Alternative)

The HTTP endpoint is available at `http://localhost:5858/codebase/mcp` when UCM is running, though this is less reliable than stdio connections.

### MCP Server Capabilities

The UCM MCP server provides AI agents with tools to:
- **Inspect and search** your Unison codebase
- **Write and typecheck** new code
- **Search Unison Share** for projects and definitions
- **Run tests** and view documentation
- **Update definitions** and manage dependencies

This enables powerful AI-assisted development workflows directly within your Unison project.

### Using Claude Code CLI

The container includes Claude Code CLI, Anthropic's AI-powered coding assistant. Once inside the container, you can use it to get AI assistance with your code.

#### First Time Setup

On first use, you'll need to authenticate with your Anthropic API key:

```bash
claude auth
```

Follow the prompts to enter your API key. Your credentials will be stored in `/root/.claude` and persisted across container restarts.

#### UCM MCP Server - Pre-Configured! ✅

**Good news**: The UCM MCP server is already configured for you via the `.mcp.json` file in your workspace root!

When you run `claude`, it will **automatically**:
- ✅ Start the UCM MCP server (`ucm mcp`)
- ✅ Connect via stdio transport
- ✅ Provide Unison-specific AI assistance

You don't need any manual configuration. Just authenticate once (see above) and start coding!

The MCP server gives Claude access to:
- **Typechecking** your Unison code
- **Searching definitions** in your codebase and libraries
- **Running tests** to verify your code
- **Viewing documentation** for functions and types
- **Searching Unison Share** for libraries and projects

To verify the MCP server is configured:

```bash
# List configured MCP servers
claude mcp list

# Or check within a Claude session
claude
# Then type: /mcp
```

#### Basic Usage

```bash
# Start an interactive coding session
claude

# Run with a specific prompt
claude -p "Explain the carbonIntensity.u file"

# Continue a previous conversation
claude -c

# Get help
claude --help
```

#### Common Commands

- **Interactive mode**: `claude` - Start a chat session for iterative development
- **One-off prompts**: `claude -p "your prompt here"` - Get quick answers or code snippets
- **Continue conversation**: `claude -c` - Resume your last coding session
- **Specify files**: `claude -p "Fix the bug in aggregations.u"` - Claude will read and analyze the file

#### Credential Persistence

Your Claude Code credentials are stored in the `.claude` directory which is mounted from your local workspace, so they persist across:
- Container restarts
- Container rebuilds
- Different projects using the same devcontainer setup

#### Integration with Unison MCP Server

The UCM MCP server is **pre-configured** (via `.mcp.json`) and provides seamless integration:

- **Automatic startup**: No need to manually run `ucm mcp` - Claude handles it automatically
- **Context-aware assistance**: Claude can typecheck, search, and run tests on your Unison code
- **Zero configuration**: Works out of the box after authentication

Inside a Claude session, check MCP server status and available tools:
```
/mcp
```

This displays all connected MCP servers and their capabilities.

### Using Beads (bd CLI)

Beads is an AI-assisted development CLI tool that helps with various development tasks. Once inside the container, you can use the `bd` command.

#### First Time Setup

Initialize beads in your project:

```bash
cd /workspace
bd init --quiet
```

This creates the necessary configuration files for beads to work in your project.

#### Basic Usage

```bash
# Check beads version
bd version

# Get help
bd help

# Use beads for AI-assisted development
bd <command>
```

#### What is Beads?

Beads (`bd`) is a CLI tool for AI-assisted development that provides:
- AI-powered code assistance
- Development workflow automation
- Integration with AI models for code generation and analysis
- Project-specific context management

For more information, visit the [Beads GitHub repository](https://github.com/steveyegge/beads).

## Configuration Files

- **devcontainer.json**: VS Code dev container configuration
- **Dockerfile**: Container image definition using Chainguard Node.js development image
- **.dockerignore**: Files to exclude from the build context
- **../.mcp.json**: Project-scoped MCP server configuration (UCM pre-configured for Claude CLI)
- **mcp-config.json**: MCP server configuration template for other MCP clients
- **start-mcp-server.sh**: Convenience script to manually start the UCM MCP server (not needed for Claude CLI)

## Customization

### Installing Additional Tools

Edit the `Dockerfile` and add packages using `apk`:

```dockerfile
RUN apk add --no-cache <package-name>
```

### VS Code Extensions

Add extensions to the `devcontainer.json`:

```json
"customizations": {
  "vscode": {
    "extensions": [
      "unison.unison",
      "your-extension-id"
    ]
  }
}
```

## Security Benefits

Using Chainguard images provides:
- **Minimal CVEs**: Images are rebuilt nightly with latest security patches
- **SBOM included**: Software Bill of Materials for transparency
- **Signed with Sigstore**: Cryptographic verification of image provenance
- **SLSA provenance**: Build attestations for supply chain security

## Resources

- [Chainguard Images Documentation](https://edu.chainguard.dev/chainguard/chainguard-images/)
- [Unison Documentation](https://www.unison-lang.org/docs/)
- [Unison MCP Setup Guide](https://www.unison-lang.org/docs/usage-topics/mcp-setup/)
- [Claude Code Documentation](https://code.claude.com/docs/)
- [Claude Code in Dev Containers](https://code.claude.com/docs/en/devcontainer)
- [Beads GitHub Repository](https://github.com/steveyegge/beads)
- [Beads Installation Guide](https://github.com/steveyegge/beads/blob/main/docs/INSTALLING.md)
- [Dev Containers Specification](https://containers.dev/)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
