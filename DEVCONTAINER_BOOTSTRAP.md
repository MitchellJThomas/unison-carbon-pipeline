# DevContainer Bootstrap Configuration

This document explains the automatic bootstrap configuration for the Unison carbon-pipeline project in GitHub Codespaces and VS Code Dev Containers.

## Problem Solved

When a new developer opens this project in a fresh codespace:
- ❌ Previously: Empty Unison codebase, no definitions loaded
- ✅ Now: Fully initialized `carbon-pipeline` project with all code ready

## Solution Overview

The devcontainer is configured to **automatically bootstrap** the Unison project on creation, loading all source files and installing dependencies.

---

## 🎯 Automatic Bootstrap Process

### What Happens

When you create a new codespace or open the project in a dev container, the `postCreateCommand` in `devcontainer.json` automatically runs:

```bash
.devcontainer/bootstrap-unison-project.sh
```

This script performs a complete 7-step initialization:

### Step 1: Check UCM Installation
Verifies Unison Codebase Manager is installed and working.

### Step 2: Initialize Codebase
Creates the `.unison/v2/` directory structure if it doesn't exist.

### Step 3: Create Project
Creates the `carbon-pipeline` project with `main` branch.

### Step 4: Install Libraries
Installs required dependencies from Unison Share:
- `@unison/json/releases/1.3.5` → `lib.unison_json_1_3_5`
- Base library is included automatically

### Step 5: Load Source Files
Loads and adds all `.u` files to the project:
- `carbonIntensity.u` - Core data types and utilities
- `aggregations.u` - Statistical analysis functions
- `cleanDecoder.u` - JSON decoder with combinators
- `README.u` - Project documentation (if present)

### Step 6: Verify Setup
- Counts definitions in project
- Verifies key types exist (CarbonIntensityRecord)
- Reports project status

### Step 7: Run Initial Tests
Executes `testAggregations` to verify everything works.

---

## 📁 Files Modified/Created

### Modified Files

**`.devcontainer/devcontainer.json`**
- Updated `postCreateCommand` to run bootstrap script
- Updated `initializeCommand` to create `scripts/` directory

**`.devcontainer/Dockerfile`**
- Added copy and chmod for `bootstrap-unison-project.sh`
- Makes script available in container at `/usr/local/bin/bootstrap-unison-project`

**`.devcontainer/README.md`**
- Added comprehensive "Automatic Project Bootstrap" section
- Added "Expected Bootstrap Output" with sample
- Added "Troubleshooting Bootstrap" guide
- Added "GitHub Codespaces" specific instructions
- Updated Configuration Files section

### Created Files

**`.devcontainer/bootstrap-unison-project.sh`** (242 lines)
Complete bootstrap automation script:
- Checks prerequisites
- Initializes codebase
- Creates project
- Installs libraries
- Loads source files
- Verifies setup
- Runs tests
- Provides detailed colored output

**`scripts/manual-bootstrap.sh`** (32 lines)
Manual re-bootstrap script for developers:
- Prompts for confirmation
- Runs the bootstrap script
- Useful for re-initializing after code changes

---

## 🚀 Developer Experience

### First Time Opening Project

#### GitHub Codespaces:
1. Click "Code" → "Codespaces" → "Create codespace on main"
2. Wait 2-3 minutes for container build
3. Watch automatic bootstrap in terminal
4. ✅ Project ready with 34 definitions loaded!

#### VS Code Dev Containers:
1. Open project in VS Code
2. Click "Reopen in Container" prompt
3. Wait for container build and bootstrap
4. ✅ Project ready to use!

### What Developers See

```
🚀 Bootstrapping Unison Carbon Pipeline Project...

[1/7] Checking UCM installation...
✅ UCM installed: unison version: release/1.0.2

[2/7] Initializing Unison codebase...
✅ Codebase initialized

[3/7] Creating carbon-pipeline project...
✅ Project created: carbon-pipeline/main

[4/7] Installing required libraries...
✅ Libraries installed

[5/7] Loading source files into project...
  ✅ carbonIntensity.u loaded
  ✅ aggregations.u loaded
  ✅ cleanDecoder.u loaded

[6/7] Verifying project setup...
✅ Found 34 definitions in project
✅ CarbonIntensityRecord type found

[7/7] Running initial tests...
✅ Tests are working!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Bootstrap Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Project: carbon-pipeline/main
📊 Definitions: 34
🔧 MCP Server: Pre-configured in .mcp.json

🎯 Next Steps:

For Claude Code development:
  • Use MCP tools (see CLAUDE.md)
  • mcp__unison__list-project-definitions({...})

For manual development:
  • Start UCM: ucm
  • Run tests: .> run testAggregations
  • List code: .> ls

📖 Documentation:
  • CLAUDE.md - Claude Code development guide
  • MCP_CONFIGURATION.md - MCP tool reference
  • CARBON_PIPELINE_PROJECT.md - Project details
  • ./scripts/project-info.sh - Quick overview
```

### Immediate Use

After bootstrap completes, developers can immediately:

**Option 1: Claude Code (MCP)**
```javascript
mcp__unison__get-current-project-context()
// => {projectName: "carbon-pipeline", branchName: "main"}

mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
// => Lists all 34 definitions

mcp__unison__run({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  mainFunctionName: "testAggregations",
  args: []
})
// => Runs tests successfully
```

**Option 2: UCM**
```bash
ucm
.> ls                        # See 34 definitions
.> run testAggregations      # Run tests
.> view averageCarbonIntensity  # View source
```

**Option 3: Helper Scripts**
```bash
./scripts/project-info.sh    # Project overview
./scripts/run-tests.sh       # Run all tests
./scripts/verify-project.sh  # Verify setup
```

---

## 🔧 Manual Re-Bootstrap

### When Needed

Re-bootstrap if:
- Source files were updated and need to be reloaded
- Definitions are missing from the project
- Library versions need to be updated
- Project got into an inconsistent state

### How to Re-Bootstrap

**Interactive (recommended):**
```bash
./scripts/manual-bootstrap.sh
```

**Direct:**
```bash
.devcontainer/bootstrap-unison-project.sh
```

**From anywhere:**
```bash
bootstrap-unison-project
# (script is in PATH as /usr/local/bin/bootstrap-unison-project)
```

---

## 🐛 Troubleshooting

### Bootstrap Failed

**Check UCM is installed:**
```bash
ucm version
```

**Check .unison directory:**
```bash
ls -la .unison/v2/
```

**Check source files exist:**
```bash
ls -la *.u
```

**Re-run bootstrap:**
```bash
./scripts/manual-bootstrap.sh
```

### Definitions Missing

**Check project exists:**
```bash
echo "projects" | ucm
# Should show: carbon-pipeline
```

**List definitions:**
```bash
echo "ls" | ucm
# Should show 34+ definitions
```

**Reload a specific file:**
```bash
ucm
.> load carbonIntensity.u
.> add
```

### Library Issues

**Check installed libraries:**
```bash
echo "ls lib" | ucm
```

**Reinstall JSON library:**
```bash
ucm
.> pull @unison/json/releases/1.3.5 lib.unison_json_1_3_5
```

### MCP Server Issues

**Verify MCP configuration:**
```bash
cat .mcp.json
```

**Test MCP server manually:**
```bash
ucm mcp
# Should start MCP server in stdio mode
```

**Check with Claude Code:**
```bash
claude mcp list
# Should show "unison" server
```

---

## 🔍 Technical Details

### Bootstrap Script Location

- **In container**: `/usr/local/bin/bootstrap-unison-project` (in PATH)
- **In workspace**: `.devcontainer/bootstrap-unison-project.sh`
- **Manual script**: `scripts/manual-bootstrap.sh`

### UCM Commands Used

The bootstrap script uses these UCM commands via piped input:

```bash
# Create project
echo "project.create carbon-pipeline" | ucm

# Install library
echo "pull @unison/json/releases/1.3.5 lib.unison_json_1_3_5" | ucm

# Load and add source
echo "load carbonIntensity.u" | ucm
echo "add" | ucm

# Verify
echo "ls" | ucm
echo "run testAggregations" | ucm
```

### Exit Codes

- `0` - Success
- `1` - UCM not found or critical error
- Script uses `set -e` to exit on any command failure

### Error Handling

- Each step reports success (✅) or warning (⚠️)
- Script continues even if optional steps fail
- Critical failures (no UCM, no codebase) exit immediately

---

## 📊 Project State After Bootstrap

### Definitions: 34 total

**Core Type:** `CarbonIntensityRecord`
**Accessors:** 16 auto-generated functions
**Utilities:** 9 functions (getCarbonIntensity, isLowCarbon, formatRecord, etc.)
**Aggregations:** 9 functions (average, min, max, filter, count, percentage)
**Tests:** 2 functions (testAggregations, testCleanDecoder)

### Libraries: 2 installed

**base** (8,725 terms, 191 types) - Unison standard library
**unison_json_1_3_5** (8,184 terms, 189 types) - JSON parsing

### MCP Server: Configured

- Pre-configured in `.mcp.json`
- Auto-starts with Claude Code CLI
- Provides 25+ tools for AI-assisted development

---

## 🎓 Benefits

### For New Developers

1. **Zero setup time** - Project is ready immediately
2. **No UCM knowledge required** - Automatic initialization
3. **Consistent environment** - Everyone starts with same state
4. **Reduced onboarding friction** - No manual steps to forget
5. **Instant productivity** - Can start coding right away

### For The Project

1. **Reproducible builds** - Exact same setup every time
2. **Version locked** - JSON library version is fixed (1.3.5)
3. **Self-documenting** - Bootstrap script shows what's needed
4. **Easy maintenance** - Update one script, not documentation
5. **CI/CD ready** - Can use same bootstrap in automated tests

### For Claude Code Users

1. **MCP server ready** - Pre-configured and verified
2. **All tools available** - Can immediately use mcp__unison__* tools
3. **Project context set** - carbon-pipeline/main is active
4. **AI assistance enabled** - Claude can explore Unison code
5. **Type-safe operations** - MCP tools validated on startup

---

## 🔮 Future Enhancements

### Potential Improvements

1. **Progress bar** - Show bootstrap progress visually
2. **Parallel installs** - Install libraries concurrently
3. **Cached layers** - Pre-install libraries in Docker image
4. **Health check** - Verify MCP server functionality
5. **Custom hooks** - Allow project-specific bootstrap steps
6. **Rollback** - Ability to undo bootstrap if it fails
7. **Bootstrap versions** - Track and report bootstrap script version

### Configuration Options

Consider adding to `devcontainer.json`:
```json
{
  "containerEnv": {
    "UNISON_BOOTSTRAP_SKIP_TESTS": "false",
    "UNISON_BOOTSTRAP_VERBOSE": "true",
    "UNISON_BOOTSTRAP_JSON_VERSION": "1.3.5"
  }
}
```

---

## 📚 Related Documentation

- **[.devcontainer/README.md](.devcontainer/README.md)** - Full devcontainer docs with bootstrap info
- **[CLAUDE.md](CLAUDE.md)** - Claude Code development guide (MCP-first)
- **[MCP_CONFIGURATION.md](MCP_CONFIGURATION.md)** - Complete MCP tool reference
- **[CARBON_PIPELINE_PROJECT.md](CARBON_PIPELINE_PROJECT.md)** - Project details and architecture
- **[BOOTSTRAP_COMPLETE.md](BOOTSTRAP_COMPLETE.md)** - Claude Code bootstrap configuration summary

---

## ✅ Verification Checklist

After bootstrap completes, verify:

- [ ] UCM version displays correctly
- [ ] `.unison/v2/` directory exists
- [ ] `carbon-pipeline` project exists
- [ ] 34+ definitions are loaded
- [ ] `CarbonIntensityRecord` type is found
- [ ] Tests run successfully
- [ ] MCP server is configured (`.mcp.json` exists)
- [ ] Helper scripts are executable
- [ ] Documentation files are present

Run this verification:
```bash
./scripts/verify-project.sh
```

---

**Status**: ✅ COMPLETE - Automatic devcontainer bootstrap configured

**Last Updated**: 2026-01-19

**Tested With**:
- GitHub Codespaces
- VS Code Dev Containers
- Docker Desktop

**UCM Version**: release/1.0.2
