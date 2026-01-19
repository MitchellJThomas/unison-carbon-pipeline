#!/bin/bash
# Verify carbon-pipeline project setup and health

set -e

echo "🔍 Verifying carbon-pipeline project..."
echo ""

# Check if UCM is installed
if ! command -v ucm &> /dev/null; then
    echo "❌ UCM not found. Please install Unison."
    exit 1
fi
echo "✅ UCM installed: $(ucm version 2>&1 | head -1 || echo 'version check failed')"

# Check if .unison directory exists
if [ ! -d ".unison" ]; then
    echo "❌ .unison directory not found. Run 'ucm' to initialize."
    exit 1
fi
echo "✅ Unison codebase found"

# Check if MCP config exists
if [ ! -f ".mcp.json" ]; then
    echo "⚠️  .mcp.json not found"
else
    echo "✅ MCP configuration found"
fi

# Check if key source files exist
echo ""
echo "📁 Checking source files..."
for file in carbonIntensity.u cleanDecoder.u aggregations.u; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file missing"
    fi
done

# Check if data file exists
echo ""
echo "📊 Checking data files..."
if [ -f "data/electricity_maps_sample_data.json" ]; then
    echo "  ✅ Sample data found"
else
    echo "  ❌ Sample data missing"
fi

echo ""
echo "✨ Verification complete!"
echo ""
echo "To use with Claude Code:"
echo "  1. Ensure .mcp.json is configured"
echo "  2. Use MCP tools: mcp__unison__get-current-project-context()"
echo "  3. See CLAUDE.md and MCP_CONFIGURATION.md for details"
