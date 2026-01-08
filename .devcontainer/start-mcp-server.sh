#!/bin/bash
# Start the UCM MCP Server
# This script starts the Unison Codebase Manager MCP server

echo "Starting UCM MCP Server..."
echo "MCP server will be available via stdio at: ucm mcp"
echo "HTTP endpoint (if needed): http://localhost:5858/codebase/mcp"
echo ""
echo "To connect via stdio (recommended):"
echo "  command: /usr/local/bin/ucm"
echo "  args: [\"mcp\"]"
echo ""

# Start UCM MCP server
ucm mcp
