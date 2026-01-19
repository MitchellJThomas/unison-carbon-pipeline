#!/bin/bash
# Manual bootstrap script for developers who need to re-initialize
# the Unison project after it was created

set -e

echo "🔧 Manual Unison Project Bootstrap"
echo ""
echo "This script will re-initialize the carbon-pipeline project."
echo "⚠️  WARNING: This will reload all .u files from scratch."
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Starting bootstrap..."
echo ""

# Run the devcontainer bootstrap script
if [ -f ".devcontainer/bootstrap-unison-project.sh" ]; then
    .devcontainer/bootstrap-unison-project.sh
else
    echo "❌ Bootstrap script not found at .devcontainer/bootstrap-unison-project.sh"
    exit 1
fi

echo ""
echo "✅ Manual bootstrap complete!"
echo ""
echo "You can now use the project:"
echo "  • Claude Code: Use MCP tools"
echo "  • Manual: ucm"
echo ""
