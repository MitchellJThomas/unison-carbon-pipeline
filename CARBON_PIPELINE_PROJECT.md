# Carbon Pipeline Project

A Unison functional programming project for carbon-aware data pipeline processing.

## Project Information

- **Project Name**: `carbon-pipeline`
- **Branch**: `main`
- **Location**: `.unison/v2/`
- **Created**: 2026-01-19

## Current State

### Definitions (34 total)

**Core Type**
- `CarbonIntensityRecord` - Record type with 5 fields + 16 generated accessors

**Utility Functions (9)**
- `getCarbonIntensity` - Extract carbon intensity value
- `isLowCarbon` - Check if below threshold
- `isVeryLowCarbon` - Check if below 300 gCO2eq/kWh
- `isEstimatedReading` - Check if data is estimated
- `formatRecord` - Format record as text
- `sampleRecord` - Single sample record
- `sampleRecords` - Collection of sample records
- `carbonIntensityDecoder` - JSON decoder
- `loadAndDecodeClean` - Load JSON from file

**Aggregation Functions (9)**
- `extractCarbonValues` - Extract just the Nat values
- `averageCarbonIntensity` - Calculate average
- `minCarbonIntensity` / `minCarbonValue` - Find minimum
- `maxCarbonIntensity` / `maxCarbonValue` - Find maximum
- `filterLowCarbon` - Filter by threshold
- `countLowCarbon` - Count records below threshold
- `percentageLowCarbon` - Calculate percentage

**Test Functions (2)**
- `testAggregations` - Test aggregation functions
- `testCleanDecoder` - Test JSON decoder

### Installed Libraries

**base** (8,725 terms, 191 types)
- Standard library
- List, Map, Set, Optional, Either, etc.
- IO, Exception abilities
- Text, Nat, Int operations

**unison_json_1_3_5** (8,184 terms, 189 types)
- JSON parsing (`Json.fromText`)
- Decoder combinators (`Decoder.run`, `object.at!`)
- Type-safe JSON decoding

## Development Workflow

### With Claude Code (MCP Tools)

**1. Check project status**
```javascript
mcp__unison__get-current-project-context()
// => {projectName: "carbon-pipeline", branchName: "main"}

mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
```

**2. Search and explore**
```javascript
// Search by name
mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "carbon"
})

// Search by type
mcp__unison__search-by-type({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "[CarbonIntensityRecord] -> Optional Float"
})

// View source
mcp__unison__view-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  names: ["averageCarbonIntensity"]
})
```

**3. Develop new code**
```javascript
// 1. Edit .u files directly
// 2. Typecheck
mcp__unison__typecheck-code({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  code: {filePath: "/workspace/myNewCode.u"}
})

// 3. Run tests
mcp__unison__run({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  mainFunctionName: "testAggregations",
  args: []
})
```

**4. Install dependencies**
```javascript
// Search Unison Share
mcp__unison__share-project-search({query: "http client"})

// Install library
mcp__unison__lib-install({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  libProjectName: "@unison/http",
  libBranchName: null
})
```

**5. Run all tests**
```javascript
mcp__unison__run-tests({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  subnamespace: null
})
```

### Manual Development (UCM)

```bash
# Start UCM in the project
ucm

# Load a file
.> load carbonIntensity.u

# Add new definitions
.> add

# Update existing definitions
.> update

# Run a function
.> run testAggregations

# List definitions
.> ls

# Search for definitions
.> find average
```

## Source Files

### carbonIntensity.u
Core data type and utility functions.

```unison
type CarbonIntensityRecord =
  { zone : Text
  , carbonIntensity : Nat
  , datetime : Text
  , isEstimated : Boolean
  , estimationMethod : Optional Text
  }

getCarbonIntensity : CarbonIntensityRecord -> Nat
isLowCarbon : Nat -> CarbonIntensityRecord -> Boolean
isVeryLowCarbon : CarbonIntensityRecord -> Boolean
formatRecord : CarbonIntensityRecord -> Text
```

### cleanDecoder.u
JSON decoder using combinators.

```unison
use lib.unison_json_1_3_5.Decoder

carbonIntensityDecoder : '{Decoder} CarbonIntensityRecord
carbonIntensityDecoder = do
  zone = object.at! "zone" Decoder.text
  carbon = object.at! "carbonIntensity" Decoder.nat
  datetime = object.at! "datetime" Decoder.text
  estimated = object.at! "isEstimated" Decoder.boolean
  method = object.optionalAt! "estimationMethod" Decoder.text
  CarbonIntensityRecord zone carbon datetime estimated method

loadAndDecodeClean : '{IO, Exception} CarbonIntensityRecord
loadAndDecodeClean = do
  bytes = readFile (FilePath "data/electricity_maps_sample_data.json")
  text = Text.fromUtf8 bytes
  Decoder.run carbonIntensityDecoder text
```

### aggregations.u
Statistical analysis and filtering functions.

```unison
averageCarbonIntensity : [CarbonIntensityRecord] -> Optional Float
minCarbonIntensity : [CarbonIntensityRecord] -> Optional CarbonIntensityRecord
maxCarbonIntensity : [CarbonIntensityRecord] -> Optional CarbonIntensityRecord
filterLowCarbon : Nat -> [CarbonIntensityRecord] -> [CarbonIntensityRecord]
countLowCarbon : Nat -> [CarbonIntensityRecord] -> Nat
percentageLowCarbon : Nat -> [CarbonIntensityRecord] -> Optional Float
```

## Testing

### Run Tests via MCP
```javascript
// Run specific test
mcp__unison__run({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  mainFunctionName: "testAggregations",
  args: []
})

// Run all tests
mcp__unison__run-tests({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  subnamespace: null
})
```

### Run Tests via UCM
```bash
ucm
.> run testAggregations
.> run testCleanDecoder
```

### Expected Test Output

**testAggregations**:
```
=== Testing Aggregation Functions ===

Sample size: 5 records
Carbon values: [250, 564, 180, 420, 290]

Average: 340.8 gCO2eq/kWh
Min: 180 gCO2eq/kWh at 2025-11-15T03:00:00.000Z
Max: 564 gCO2eq/kWh at 2025-11-15T02:00:00.000Z

Low carbon readings (< 300): 3
Percentage low carbon: 60.0%

✓ All aggregation functions working!
```

## Common Tasks

### View All Definitions
```javascript
mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
```

### View Dependencies
```javascript
mcp__unison__list-definition-dependencies({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  definitionName: "averageCarbonIntensity"
})
```

### View Dependents
```javascript
mcp__unison__list-definition-dependents({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  definitionName: "CarbonIntensityRecord"
})
```

### Rename a Definition
```javascript
mcp__unison__rename-definition({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  oldName: "getCarbonIntensity",
  newNameSegment: "extractCarbonIntensity"
})
```

### Move to Namespace
```javascript
mcp__unison__move-to({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  sources: ["getCarbonIntensity", "isLowCarbon"],
  destination: "utils"
})
```

## Architecture

### Type-Safe JSON Decoding
The project uses Decoder combinators for type-safe JSON parsing:
- `Decoder.text` - Decode text
- `Decoder.nat` - Decode natural numbers
- `Decoder.boolean` - Decode booleans
- `object.at!` - Required field
- `object.optionalAt!` - Optional field

### Functional List Processing
All list operations are tail-recursive with accumulating parameters:
- Build lists in order using `:+` (append to end)
- Pattern match with `x +: xs` (prepend destructuring)
- Use `List.foldLeft` for reductions

### Ability System
Effects are explicit in the type system:
- `'{IO, Exception}` - Functions that do I/O or throw exceptions
- `'{Decoder}` - Functions that decode JSON
- Pure functions have no ability annotations

## Next Steps

### Phase 2: Pipeline Composition
- [ ] Install HTTP library: `@unison/http`
- [ ] Create API client for Electricity Maps
- [ ] Implement data fetching pipeline
- [ ] Add error handling and retries

### Phase 3: Apache Iceberg Integration
- [ ] Research Iceberg libraries for Unison
- [ ] Create table schema for carbon data
- [ ] Implement write operations
- [ ] Add query capabilities

### Phase 4: Distributed Processing
- [ ] Explore distributed computing in Unison
- [ ] Implement map-reduce patterns
- [ ] Add fault tolerance
- [ ] Carbon-aware scheduling

## Resources

- **Language Guide**: Access via `ReadMcpResourceTool(server="unison", uri="file://unison-guide")`
- **MCP Documentation**: `MCP_CONFIGURATION.md`
- **Project Guide**: `CLAUDE.md`
- **Unison Docs**: https://www.unison-lang.org/docs/
- **Unison Share**: https://share.unison-lang.org
