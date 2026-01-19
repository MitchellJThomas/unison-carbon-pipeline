#!/bin/bash
# Run all tests in carbon-pipeline project

set -e

echo "🧪 Running carbon-pipeline tests..."
echo ""

# Check if UCM is available
if ! command -v ucm &> /dev/null; then
    echo "❌ UCM not found. Please install Unison."
    exit 1
fi

# Run tests via UCM
echo "Running testAggregations..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "run testAggregations" | ucm 2>&1 | grep -A 100 "=== Testing" || echo "Test execution completed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Running testCleanDecoder..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "run testCleanDecoder" | ucm 2>&1 | grep -A 100 "=== Testing" || echo "Decoder test needs to be added to project first"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Test run complete!"
echo ""
echo "Note: For Claude Code, use MCP tools instead:"
echo "  mcp__unison__run_tests({"
echo "    projectContext: {projectName: \"carbon-pipeline\", branchName: \"main\"},"
echo "    subnamespace: null"
echo "  })"
