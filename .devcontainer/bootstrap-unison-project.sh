#!/bin/bash
# Bootstrap script for Unison carbon-pipeline project
# This script initializes a fresh codespace with the project fully loaded

set -e

echo "🚀 Bootstrapping Unison Carbon Pipeline Project..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to workspace directory
cd /workspace

# Step 1: Check UCM installation
echo -e "${BLUE}[1/7]${NC} Checking UCM installation..."
if ! command -v ucm &> /dev/null; then
    echo "❌ UCM not found. Cannot proceed."
    exit 1
fi
UCM_VERSION=$(ucm version 2>&1 | head -1 || echo "unknown")
echo -e "${GREEN}✅${NC} UCM installed: ${UCM_VERSION}"
echo ""

# Step 2: Initialize Unison codebase if needed
echo -e "${BLUE}[2/7]${NC} Initializing Unison codebase..."
if [ ! -d ".unison/v2" ]; then
    echo "Creating new Unison codebase..."
    # Start UCM briefly to initialize the codebase
    echo "exit" | ucm > /dev/null 2>&1 || true
    echo -e "${GREEN}✅${NC} Codebase initialized"
else
    echo -e "${GREEN}✅${NC} Codebase already exists"
fi
echo ""

# Step 3: Create carbon-pipeline project
echo -e "${BLUE}[3/7]${NC} Creating carbon-pipeline project..."
cat <<'EOF' | ucm > /dev/null 2>&1 || true
project.create carbon-pipeline
exit
EOF
echo -e "${GREEN}✅${NC} Project created: carbon-pipeline/main"
echo ""

# Step 4: Install required libraries
echo -e "${BLUE}[4/7]${NC} Installing required libraries..."
echo "This may take a moment..."

# Install JSON library
cat <<'EOF' | ucm 2>&1 | grep -E "(installed|already)" || true
pull @unison/json/releases/1.3.5 lib.unison_json_1_3_5
exit
EOF
echo -e "${GREEN}✅${NC} Libraries installed"
echo ""

# Step 5: Load source files into project
echo -e "${BLUE}[5/7]${NC} Loading source files into project..."

# Load and add carbonIntensity.u
if [ -f "carbonIntensity.u" ]; then
    echo "Loading carbonIntensity.u..."
    cat <<'EOF' | ucm > /dev/null 2>&1 || true
load carbonIntensity.u
add
exit
EOF
    echo -e "${GREEN}  ✅${NC} carbonIntensity.u loaded"
else
    echo -e "${YELLOW}  ⚠️${NC}  carbonIntensity.u not found"
fi

# Load and add aggregations.u
if [ -f "aggregations.u" ]; then
    echo "Loading aggregations.u..."
    cat <<'EOF' | ucm > /dev/null 2>&1 || true
load aggregations.u
add
exit
EOF
    echo -e "${GREEN}  ✅${NC} aggregations.u loaded"
else
    echo -e "${YELLOW}  ⚠️${NC}  aggregations.u not found"
fi

# Load and add cleanDecoder.u
if [ -f "cleanDecoder.u" ]; then
    echo "Loading cleanDecoder.u..."
    cat <<'EOF' | ucm > /dev/null 2>&1 || true
load cleanDecoder.u
add
exit
EOF
    echo -e "${GREEN}  ✅${NC} cleanDecoder.u loaded"
else
    echo -e "${YELLOW}  ⚠️${NC}  cleanDecoder.u not found"
fi

# Load and add README.u if it exists
if [ -f "README.u" ]; then
    echo "Loading README.u..."
    cat <<'EOF' | ucm > /dev/null 2>&1 || true
load README.u
add
exit
EOF
    echo -e "${GREEN}  ✅${NC} README.u loaded"
fi

echo ""

# Step 6: Verify the setup
echo -e "${BLUE}[6/7]${NC} Verifying project setup..."

# Count definitions
DEFINITION_COUNT=$(echo "ls" | ucm 2>&1 | grep -E "^\s+[0-9]+\." | wc -l || echo "0")
echo -e "${GREEN}✅${NC} Found ${DEFINITION_COUNT} definitions in project"

# Check if key types exist
echo "find CarbonIntensityRecord" | ucm 2>&1 | grep -q "CarbonIntensityRecord" && \
    echo -e "${GREEN}✅${NC} CarbonIntensityRecord type found" || \
    echo -e "${YELLOW}⚠️${NC}  CarbonIntensityRecord type not found"

echo ""

# Step 7: Run tests
echo -e "${BLUE}[7/7]${NC} Running initial tests..."
echo "run testAggregations" | ucm 2>&1 | grep -q "Testing Aggregation" && \
    echo -e "${GREEN}✅${NC} Tests are working!" || \
    echo -e "${YELLOW}⚠️${NC}  Tests may need attention"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✨ Bootstrap Complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📦 Project: carbon-pipeline/main"
echo "📊 Definitions: ${DEFINITION_COUNT}"
echo "🔧 MCP Server: Pre-configured in .mcp.json"
echo ""
echo "🎯 Next Steps:"
echo ""
echo "For Claude Code development:"
echo "  • Use MCP tools (see CLAUDE.md)"
echo "  • mcp__unison__list-project-definitions({...})"
echo ""
echo "For manual development:"
echo "  • Start UCM: ucm"
echo "  • Run tests: .> run testAggregations"
echo "  • List code: .> ls"
echo ""
echo "📖 Documentation:"
echo "  • CLAUDE.md - Claude Code development guide"
echo "  • MCP_CONFIGURATION.md - MCP tool reference"
echo "  • CARBON_PIPELINE_PROJECT.md - Project details"
echo "  • ./scripts/project-info.sh - Quick overview"
echo ""
