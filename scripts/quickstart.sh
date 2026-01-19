#!/bin/bash
# Quick start script for carbon-pipeline project

set -e

echo "🚀 Carbon Pipeline Quick Start"
echo ""

# Check prerequisites
echo "Checking prerequisites..."
if ! command -v ucm &> /dev/null; then
    echo "❌ UCM not installed"
    echo ""
    echo "Please install Unison from: https://www.unison-lang.org/install"
    exit 1
fi
echo "✅ UCM installed"

# Check if .unison exists
if [ ! -d ".unison" ]; then
    echo ""
    echo "⚠️  Unison codebase not initialized"
    echo "Initializing now..."
    echo ""
    echo "project.switch carbon-pipeline/main" | ucm
    echo ""
    echo "✅ Codebase initialized"
fi

# Verify project
echo ""
echo "Verifying project setup..."
./scripts/verify-project.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Quick Start Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo ""
echo "1. For Claude Code development:"
echo "   • Read CLAUDE.md for MCP workflow"
echo "   • Use MCP tools (see MCP_CONFIGURATION.md)"
echo "   • Check project status:"
echo "     mcp__unison__list-project-definitions({...})"
echo ""
echo "2. For manual development:"
echo "   • Start UCM: ucm"
echo "   • Load code: .> load carbonIntensity.u"
echo "   • Run tests: .> run testAggregations"
echo ""
echo "3. Helpful scripts:"
echo "   • ./scripts/project-info.sh - Project overview"
echo "   • ./scripts/run-tests.sh - Run all tests"
echo "   • ./scripts/verify-project.sh - Verify setup"
echo ""
