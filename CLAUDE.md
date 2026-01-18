# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Unison** functional programming project that builds a carbon-aware data pipeline for processing grid carbon intensity data from the Electricity Maps API. The project demonstrates content-addressed, distributed computing principles while analyzing electricity grid emissions patterns.

## Unison Development Workflow

This project uses Unison, which has a fundamentally different development model than traditional file-based languages:

### Content-Addressed Code
- Functions are stored by hash, not by name
- Code is never "compiled" in the traditional sense - it's always ready to run
- The `.unison` directory contains the codebase database (never modify manually)
- `.u` files are "scratch files" used to introduce definitions into UCM

### REPL-Driven Development
All development happens through the **UCM (Unison Codebase Manager)** REPL:

1. **Start UCM**: `ucm` (opens the Unison REPL prompt: `.>`)
2. **Load scratch files**: `.> load filename.u` (typechecks and shows definitions)
3. **Add new definitions**: `.> add` (persists to content-addressed codebase)
4. **Update existing code**: `.> update` (modifies existing definitions and their dependents)
5. **Run functions**: `.> run functionName` (executes IO functions)
6. **Search definitions**: `.> find searchTerm` (finds in local codebase)
7. **Search libraries**: `.> find-in.all lib searchTerm` (searches installed libraries)

### Working with Scratch Files
- Edit `.u` files with regular text editors
- Load them into UCM with `load filename.u`
- UCM typechecks and shows what's new or changed
- Use `add` for new code, `update` for modifications
- The `update` command automatically handles dependent code updates
- Never directly "run" a `.u` file - always go through UCM

## Common Development Commands

### UCM Commands
```bash
# Start Unison Codebase Manager
ucm

# Inside UCM:
.> load carbonIntensity.u           # Load and typecheck a scratch file
.> add                              # Add new definitions to codebase
.> update                           # Update existing definitions
.> run testAggregations             # Run an IO function
.> find carbonIntensity             # Search local codebase
.> find-in.all lib json             # Search all libraries
.> ls                               # List definitions in current namespace
```

### Updating Existing Code
The recommended workflow for modifying existing definitions:
1. **Edit code**: Use `edit termName` to bring a definition into your scratch file, or manually edit a `.u` file
2. **Load changes**: Use `load filename.u` to typecheck
3. **Update codebase**: Use `update` to save changes and update all dependents
4. **Resolve conflicts**: If UCM finds issues, it will open your editor with non-typechecking code
5. **Iterate**: Fix issues and run `update` again until successful

### Running Tests
All test functions are executable through UCM:
```bash
ucm
.> run testAggregations             # Test aggregation functions with sample data
.> run testCleanDecoder             # Test JSON decoder
```

### MCP Server (AI Integration)
The Unison MCP server enables AI-assisted development:
```bash
# Start MCP server (stdio mode - recommended)
ucm mcp

# Or use the convenience script
start-mcp-server
```

The MCP server is pre-configured in `.mcp.json` for Claude Code CLI and provides:
- Code typechecking and validation
- Definition search and exploration
- Test execution
- Library management
- Unison Share integration

## Code Architecture

### Core Data Model
The pipeline centers on `CarbonIntensityRecord`, which represents a single carbon intensity reading:

```unison
type CarbonIntensityRecord =
  { zone : Text                      -- Grid zone identifier (e.g., "US-NW-PGE")
  , carbonIntensity : Nat            -- gCO2eq/kWh
  , datetime : Text                  -- ISO 8601 timestamp
  , isEstimated : Boolean            -- Whether data is estimated
  , estimationMethod : Optional Text -- Estimation methodology if applicable
  }
```

### Module Organization

**carbonIntensity.u**
- Core data type definition
- Helper functions: `getCarbonIntensity`, `isLowCarbon`, `formatRecord`
- Sample data for REPL exploration

**cleanDecoder.u**
- JSON decoder using `lib.json_1_2_1.Decoder` combinators
- Decoder composition pattern with `object.at!`
- File I/O integration for loading JSON data

**aggregations.u**
- Statistical analysis functions: `averageCarbonIntensity`, `minCarbonIntensity`, `maxCarbonIntensity`
- Filtering and threshold functions: `filterLowCarbon`, `countLowCarbon`, `percentageLowCarbon`
- Comprehensive test harness with sample data

### Functional Patterns Used

**Decoder Combinators**
The project uses decoder combinators from `lib.json_1_2_1.Decoder` for type-safe JSON parsing:
```unison
carbonIntensityDecoder = do
  zone = object.at! "zone" text
  carbon = object.at! "carbonIntensity" nat
  datetime = object.at! "datetime" text
  -- Composable, type-safe, elegant
```

**List Processing**
Aggregations use functional list operations:
- `List.map` - Transform values
- `List.filter` - Select by predicate
- `List.foldLeft` - Accumulate results
- `List.find` - Locate specific elements

**Optional Handling**
Functions that may not have results return `Optional` types:
```unison
averageCarbonIntensity : [CarbonIntensityRecord] -> Optional Float
minCarbonIntensity : [CarbonIntensityRecord] -> Optional CarbonIntensityRecord
```

### Ability System
Unison's effect system makes side effects explicit:
- `'{IO, Exception}` - Functions that perform I/O or may throw exceptions
- `'{Decoder}` - Functions that decode data
- Pure functions have no ability annotations

## Key Implementation Notes

### Type Safety Patterns
- Use `Nat` for non-negative values (carbon intensity is always >= 0)
- Use `Int` only when negative values are meaningful
- Explicit `Optional` handling prevents null pointer errors
- Pattern matching with `match` for safe unwrapping

### Library Dependencies
The project uses:
- `lib.json_1_2_1.core.Json` - JSON parsing
- `lib.json_1_2_1.Decoder` - Type-safe decoding with combinators

To add new libraries:
```unison
.> pull @library/name.version .lib.name
```

### File I/O
Reading files requires the `IO` ability:
```unison
loadAndDecodeClean : '{IO, Exception} CarbonIntensityRecord
loadAndDecodeClean = do
  bytes = readFile (FilePath "data/electricity_maps_sample_data.json")
  text = Text.fromUtf8 bytes
  -- Process text...
```

### Working with External APIs
Current status: Phase 1 uses sample JSON files. Phase 2+ will integrate:
- Electricity Maps API (`https://api.electricitymaps.com/v3/`)
- HTTP libraries (explore with `.> find-in.all lib http`)
- Authentication with `auth-token` header

## Project Phases

**Phase 1 (Complete)**
- JSON parsing and decoding
- Core data types
- Aggregation functions
- REPL-based testing

**Phase 2 (Planned)**
- Pipeline composition
- Apache Iceberg integration
- Error handling and validation

**Phase 3 (Planned)**
- Distributed processing across nodes
- Map-reduce patterns
- Fault tolerance

**Phase 4 (Planned)**
- Carbon-aware scheduling
- Real-time optimization
- Carbon footprint measurement

## Development Container

This project includes a devcontainer based on Chainguard's secure Node.js image with:
- Unison UCM pre-installed
- Claude Code CLI configured
- MCP server auto-configured via `.mcp.json`
- Ports forwarded: 5757 (UCM), 8080 (Unison UI), 5858 (MCP HTTP)

## Important Unison Concepts

### Content-Addressed Benefits
- Only rerun computations when code actually changes (by hash)
- Perfect for incremental data processing
- Natural caching and memoization

### REPL-First Philosophy
- Write code in `.u` files
- Load into UCM for immediate typechecking
- Test interactively with `run`
- Iterate rapidly without build steps

### Type-Driven Development
- Define types first (like `CarbonIntensityRecord`)
- Let the type system guide implementation
- Use `find` to discover functions by type signature

### Functional Purity
- Default to pure functions
- Make side effects explicit with abilities
- Compose small functions into larger pipelines

## Common Pitfalls

1. **Don't modify `.unison` directory** - It's the codebase database
2. **Always use UCM** - Never run `.u` files directly
3. **Use `update` not `add`** - When modifying existing definitions (use `add` only for new definitions)
4. **Type mismatches** - Remember `Nat` vs `Int` distinctions
5. **Ability requirements** - Functions with IO must be called in IO context

## Resources

- Main project README: `README.md`
- Phase 1 guide: `PHASE1_GUIDE.md`
- Phase 1 completion notes: `PHASE1_COMPLETE.md`
- Sample data: `data/electricity_maps_sample_data.json`
- Devcontainer docs: `.devcontainer/README.md`
