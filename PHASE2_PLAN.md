# Phase 2 Implementation Plan: API Integration + In-Memory Processing

## Context

**Why This Approach:**
The carbon pipeline's ultimate goal is **real-time computational optimization** - making decisions about when to run workloads based on current grid carbon intensity. After exploring storage options, we've chosen a more pragmatic phase sequence:

- **Phase 1 (Complete)**: File-based learning - understand data model, decoders, aggregations
- **Phase 2 (This Plan)**: Live API + in-memory processing - real-time decisions, no persistence yet
- **Phase 3 (Future)**: Add persistent storage (Volturno KLog) - historical analysis, distributed processing

**Key Insight:** Storage requirements become clear only after we understand real-time processing patterns. By deferring storage to Phase 3, we can:
1. Iterate faster in Phase 2 (simpler scope)
2. Test the real use case (live optimization decisions)
3. Learn what data we actually need to persist
4. Make informed storage decisions in Phase 3

**Data Nature:** Time-series carbon intensity measurements (numeric, estimations) used computationally to optimize and reduce carbon creation.

---

## Phase 2 Goals

### Primary Objectives
1. **API Integration** - Fetch live carbon intensity data from Electricity Maps API
2. **In-Memory Cache** - Keep recent data for computational queries (last 24-48 hours)
3. **Pipeline Composition** - Chain API → decode → validate → aggregate → decide
4. **Error Handling** - Robust handling of network failures, rate limits, bad data
5. **Real-Time Decisions** - Optimize workload scheduling based on current carbon intensity

### Explicitly Deferred to Phase 3
- ❌ Persistent storage (files, databases, KLog)
- ❌ Historical trend analysis beyond cache window
- ❌ Distributed processing
- ❌ Data durability and recovery

---

## Overall Phase Roadmap (For Future Sessions)

### Phase 1: Foundation ✅ (Complete)
- Core data types (`CarbonIntensityRecord`)
- JSON decoders with combinators
- Aggregation functions (average, min, max, filtering)
- File-based sample data processing
- **Status**: All tests passing, 38 definitions in codebase

### Phase 2: Real-Time Processing (This Plan)
- Electricity Maps API integration via `@unison/http`
- In-memory cache with time-based eviction
- Pipeline composition with `Result` error handling
- Real-time optimization decision engine
- Network error handling and retry logic
- **Target**: Make live carbon-aware scheduling decisions

### Phase 3: Persistence + Distribution (Future)
- Volturno KLog for time-series storage
- KStream for streaming aggregations
- Historical data analysis and trends
- Distributed processing across nodes
- Time-travel queries and windowed analytics
- **Target**: Production-ready distributed pipeline

### Phase 4: Carbon-Aware Optimization (Future)
- Multi-zone carbon intensity tracking
- Predictive modeling for carbon forecasting
- Automated workload scheduling
- Carbon footprint measurement and reporting
- Integration with job schedulers
- **Target**: Autonomous carbon-aware compute platform

---

## Phase 2 Detailed Implementation Plan

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Phase 2 Architecture                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────┐    ┌──────────────┐    ┌────────────────┐ │
│  │ Electricity     │    │  In-Memory   │    │  Optimization  │ │
│  │ Maps API        │───>│  Cache       │───>│  Engine        │ │
│  │ (HTTP)          │    │  (Map)       │    │  (Decisions)   │ │
│  └─────────────────┘    └──────────────┘    └────────────────┘ │
│         │                      │                      │          │
│         │ Result<Data>         │ Cached Queries       │          │
│         v                      v                      v          │
│  ┌─────────────────┐    ┌──────────────┐    ┌────────────────┐ │
│  │ Error Handling  │    │  Aggregation │    │  Output/       │ │
│  │ (Retry/Backoff) │    │  Functions   │    │  Logging       │ │
│  └─────────────────┘    └──────────────┘    └────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘

Key Data Flow:
1. API fetch → decode → validate → cache
2. Cache query → aggregate → decision
3. Errors → retry → backoff → fallback
```

---

## 🚀 START HERE: Agent Quick Start Guide

### For Fresh Sessions (No Prior Phase 2 Work)

**Step 1: Verify Phase 1 Status**
```javascript
// Check project context
mcp__unison__get-current-project-context()
// Expected: {projectName: "carbon-pipeline", branchName: "main"}

// Verify Phase 1 definitions exist
mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
// Expected: 38 definitions including CarbonIntensityRecord, aggregations

// Run Phase 1 tests to confirm baseline
mcp__unison__run({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  mainFunctionName: "testAggregations",
  args: []
})
```

**Step 2: Choose Your Workstream**
- **Workstream 1** (errors.u) - Start here if nothing exists
- **Workstream 2** (api.u) - Requires Workstream 1 complete
- **Workstream 3** (cache.u) - Can parallel with Workstream 2
- **Workstream 4** (pipeline.u) - Requires Workstreams 1, 2, 3
- **Workstream 5** (optimizer.u) - Requires Workstream 4
- **Workstream 6** (integration.u) - Requires all implementation workstreams
- **Workstream 7-8** (docs) - Final step after all code complete

**Step 3: Check Workstream Status**
```bash
# Check if file exists
ls -la /workspace/errors.u /workspace/api.u /workspace/cache.u /workspace/pipeline.u /workspace/optimizer.u /workspace/integration.u

# For existing files, check definitions
mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
# Look for: Result, PipelineError, fetchCarbonIntensity, DataCache, etc.
```

**Step 4: Begin Implementation**
Go to your chosen workstream section below and follow atomic tasks.

---

### For Resuming Sessions (Phase 2 In Progress)

**Quick Status Check:**
```javascript
// 1. Check which files exist
// Read this in bash: ls -la /workspace/*.u

// 2. Check which definitions are in codebase
mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})

// 3. Search for Phase 2 specific types
mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "Result"
})

mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "PipelineError"
})
```

**Identify Next Task:**
- If `Result` type doesn't exist → Start Workstream 1
- If `Result` exists but `fetchCarbonIntensity` doesn't → Start Workstream 2
- If API exists but `DataCache` doesn't → Start Workstream 3
- If cache exists but `carbonPipeline` doesn't → Start Workstream 4
- If pipeline exists but `optimizeWorkload` doesn't → Start Workstream 5
- If optimizer exists but `runPhase2Tests` doesn't → Start Workstream 6
- If all code exists but docs missing → Start Workstream 7

---

## Agent Handoff Protocol

### Between Senior Dev → QA Engineer

**When Senior Dev completes a workstream:**
1. **Mark complete** with comment in code:
   ```unison
   -- WORKSTREAM X COMPLETE - Ready for QA
   -- Last updated: YYYY-MM-DD
   ```

2. **Typecheck the file:**
   ```javascript
   mcp__unison__typecheck-code({
     projectContext: {projectName: "carbon-pipeline", branchName: "main"},
     code: {filePath: "/workspace/FILENAME.u"}
   })
   ```

3. **Document any known issues or TODOs** in file comments

**When QA Engineer picks up:**
1. **Read the implementation:**
   ```javascript
   mcp__unison__view-definitions({
     projectContext: {projectName: "carbon-pipeline", branchName: "main"},
     names: ["Result", "PipelineError", "Result.map", "Result.flatMap"]
   })
   ```

2. **Run existing tests** (if any)

3. **Create new tests** in integration.u

4. **Report issues** back to Senior Dev with specific examples

### Between QA Engineer → Architect

**When QA completes testing:**
1. **Document test results** in comments

2. **List coverage gaps** (what wasn't tested)

3. **Provide metrics** (tests passed/failed, coverage %)

**When Architect picks up:**
1. **Review all code and tests**

2. **Validate against Phase 2 goals**

3. **Create documentation** based on actual implementation

4. **Plan Phase 3** based on lessons learned

### Parallel Work Coordination

**These workstreams can run in parallel:**
- Workstream 2 (api.u) + Workstream 3 (cache.u) after Workstream 1 done
- Workstream 6 (tests) can start once 1-5 have skeleton code

**These workstreams must be sequential:**
- Workstream 1 → Workstream 2
- Workstream 1 → Workstream 3
- Workstreams 2,3 → Workstream 4
- Workstream 4 → Workstream 5
- Workstreams 1-5 → Workstream 6
- Workstream 6 → Workstreams 7-8

---

## MCP Tool Reference for Phase 2

### Installing Libraries
```javascript
// Install @unison/http (required for Workstream 2)
mcp__unison__lib-install({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  libProjectName: "@unison/http",
  libBranchName: null  // null = latest release
})

// Verify installation
mcp__unison__list-project-libraries({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
```

### Typechecking Files
```javascript
// Typecheck a new/modified .u file
mcp__unison__typecheck-code({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  code: {filePath: "/workspace/errors.u"}
})

// Expected success output:
// {errorMessages: [], outputMessages: ["✓ Typechecked successfully"]}

// Expected error output:
// {errorMessages: ["Type mismatch at line X"], ...}
```

### Running Functions
```javascript
// Run test functions
mcp__unison__run({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  mainFunctionName: "runPhase2Tests",
  args: []
})

// Run example functions
mcp__unison__run({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  mainFunctionName: "exampleSimpleOptimization",
  args: []
})
```

### Searching and Viewing Code
```javascript
// Search for definitions by name
mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "Result"
})

// View definition source
mcp__unison__view-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  names: ["Result", "Result.map", "Result.flatMap"]
})

// List all definitions (check progress)
mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
```

### Getting Documentation
```javascript
// Read library documentation
mcp__unison__docs({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  name: "lib.base.List.map"
})
```

---

## Work Breakdown by Role

### Senior Developer (Primary Implementation)

#### Workstream 1: Error Handling Foundation
**File:** `errors.u` (NEW)
**Estimated Time:** 2-3 hours
**Dependencies:** None (start here)
**Parallel:** Can work while others set up

**Atomic Task Checklist:**

- [ ] **Task 1.1: Create errors.u file** (10 min)
  ```javascript
  // Use Write tool to create /workspace/errors.u
  // Start with basic structure and imports
  ```
  ```unison
  -- errors.u
  -- Phase 2: Error handling types and Result monad

  use .base
  ```

- [ ] **Task 1.2: Define PipelineError type** (15 min)
  ```unison
  type PipelineError
    = ParseError Text
    | ValidationError Text
    | NetworkError Nat Text
    | RateLimitError Nat
    | ApiError Nat Text
    | CacheError Text
  ```
  **MCP Check:**
  ```javascript
  mcp__unison__typecheck-code({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    code: {filePath: "/workspace/errors.u"}
  })
  ```

- [ ] **Task 1.3: Define Result type** (10 min)
  ```unison
  type Result err ok = Ok ok | Err err
  ```
  **MCP Check:** Typecheck again

- [ ] **Task 1.4: Implement Result.map** (15 min)
  ```unison
  Result.map : (a -> b) -> Result e a -> Result e b
  Result.map f result = match result with
    Ok value -> Ok (f value)
    Err error -> Err error
  ```

- [ ] **Task 1.5: Implement Result.flatMap** (15 min)
  ```unison
  Result.flatMap : (a -> Result e b) -> Result e a -> Result e b
  Result.flatMap f result = match result with
    Ok value -> f value
    Err error -> Err error
  ```

- [ ] **Task 1.6: Implement Result.withDefault** (10 min)
  ```unison
  Result.withDefault : a -> Result e a -> a
  Result.withDefault default result = match result with
    Ok value -> value
    Err _ -> default
  ```

- [ ] **Task 1.7: Implement Result.mapError** (10 min)
  ```unison
  Result.mapError : (e1 -> e2) -> Result e1 a -> Result e2 a
  Result.mapError f result = match result with
    Ok value -> Ok value
    Err error -> Err (f error)
  ```

- [ ] **Task 1.8: Implement Result.fromOptional** (10 min)
  ```unison
  Result.fromOptional : e -> Optional a -> Result e a
  Result.fromOptional error optional = match optional with
    Some value -> Ok value
    None -> Err error
  ```

- [ ] **Task 1.9: Implement Result.toOptional** (10 min)
  ```unison
  Result.toOptional : Result e a -> Optional a
  Result.toOptional result = match result with
    Ok value -> Some value
    Err _ -> None
  ```

- [ ] **Task 1.10: Implement PipelineError.toText** (20 min)
  ```unison
  PipelineError.toText : PipelineError -> Text
  PipelineError.toText error = match error with
    ParseError msg -> "Parse error: " Text.++ msg
    ValidationError msg -> "Validation error: " Text.++ msg
    NetworkError code msg -> "Network error " Text.++ (Nat.toText code) Text.++ ": " Text.++ msg
    RateLimitError seconds -> "Rate limited. Retry after " Text.++ (Nat.toText seconds) Text.++ " seconds"
    ApiError code msg -> "API error " Text.++ (Nat.toText code) Text.++ ": " Text.++ msg
    CacheError msg -> "Cache error: " Text.++ msg
  ```

- [ ] **Task 1.11: Final typecheck** (5 min)
  ```javascript
  mcp__unison__typecheck-code({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    code: {filePath: "/workspace/errors.u"}
  })
  ```
  **Success criteria:** No error messages, all functions typecheck

- [ ] **Task 1.12: Manual verification** (10 min)
  Create simple test in errors.u:
  ```unison
  testResultCombinators : '{IO, Exception} ()
  testResultCombinators = do
    printLine "=== Testing Result Combinators ==="

    -- Test map
    result1 = Ok 5
    mapped = Result.map (x -> x * 2) result1
    printLine ("Map test: " Text.++ (match mapped with Ok x -> Nat.toText x; _ -> "FAIL"))

    -- Test flatMap
    result2 = Ok 10
    flatMapped = Result.flatMap (x -> Ok (x + 5)) result2
    printLine ("FlatMap test: " Text.++ (match flatMapped with Ok x -> Nat.toText x; _ -> "FAIL"))

    -- Test withDefault
    result3 = Err (ValidationError "test")
    defaulted = Result.withDefault 42 result3
    printLine ("WithDefault test: " Text.++ Nat.toText defaulted)

    printLine "✓ Result combinators working"
  ```
  **Run test:**
  ```javascript
  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testResultCombinators",
    args: []
  })
  ```

**Verification Complete When:**
- ✅ All 12 tasks checked off
- ✅ File typechecks with no errors
- ✅ Test function runs successfully
- ✅ Error messages are clear and actionable

**Handoff to Next Workstream:**
Add comment to errors.u:
```unison
-- WORKSTREAM 1 COMPLETE - Ready for Workstream 2 (API) and 3 (Cache)
-- All Result combinators implemented and tested
-- Error types defined for all failure modes
```

---

#### Workstream 2: API Client Integration
**File:** `api.u` (NEW)
**Estimated Time:** 4-6 hours
**Dependencies:** Workstream 1 (errors.u) must be complete
**Parallel:** Can work alongside Workstream 3 (cache.u)

**Prerequisites Check:**
```javascript
// 1. Verify errors.u exists and has Result type
mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "Result"
})
// Must find: Result, Result.map, Result.flatMap, etc.

// 2. Install @unison/http library
mcp__unison__lib-install({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  libProjectName: "@unison/http",
  libBranchName: null
})

// 3. Verify installation
mcp__unison__list-project-libraries({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})
// Should see: http library listed
```

**Atomic Task Checklist:**

- [ ] **Task 2.1: Create api.u scaffold** (15 min)
  ```unison
  -- api.u
  -- Phase 2: Electricity Maps API client

  use .base
  use .carbonIntensity
  use .errors
  use lib.http
  ```

- [ ] **Task 2.2: Define ApiConfig type** (10 min)
  ```unison
  type ApiConfig =
    { baseUrl : Text
    , authToken : Text
    , timeout : Nat
    , retryAttempts : Nat
    , retryBackoff : Nat
    }

  -- Create default config for testing
  defaultApiConfig : Text -> ApiConfig
  defaultApiConfig token =
    ApiConfig
      "https://api.electricitymaps.com"
      token
      30000  -- 30 second timeout
      3      -- 3 retry attempts
      1000   -- 1 second base backoff
  ```

- [ ] **Task 2.3: Implement buildUri** (20 min)
  ```unison
  buildUri : ApiConfig -> Text -> Text -> Text
  buildUri config zone timestamp =
    config.baseUrl
      Text.++ "/v3/carbon-intensity/past?zone="
      Text.++ zone
      Text.++ "&datetime="
      Text.++ (urlEncode timestamp)

  -- Helper for URL encoding (basic)
  urlEncode : Text -> Text
  urlEncode text =
    -- Replace spaces with %20, etc.
    -- For Phase 2, may just use Text.replace for common cases
    Text.replace " " "%20" text
  ```
  **Test buildUri:**
  ```unison
  testBuildUri : '{IO, Exception} ()
  testBuildUri = do
    config = defaultApiConfig "test-token"
    uri = buildUri config "US-NW-PGE" "2025-11-15 05:00"
    printLine ("URI: " Text.++ uri)
    -- Expected: https://api.electricitymaps.com/v3/carbon-intensity/past?zone=US-NW-PGE&datetime=2025-11-15%2005:00
  ```

- [ ] **Task 2.4: Implement basic fetchCarbonIntensity** (45 min)
  ```unison
  fetchCarbonIntensity : ApiConfig -> Text -> Text -> '{IO, Exception} (Result PipelineError CarbonIntensityRecord)
  fetchCarbonIntensity config zone timestamp = do
    uri = buildUri config zone timestamp

    -- Create HTTP request
    request = Http.get uri
      |> Http.withHeader "auth-token" config.authToken
      |> Http.withTimeout config.timeout

    -- Execute request (wrapped in try-catch for exceptions)
    try
      response = Http.send request

      -- Check status code
      if Http.statusCode response == 200 then
        body = Http.bodyText response
        -- Decode JSON to CarbonIntensityRecord
        match Decoder.run carbonIntensityDecoder body with
          record -> Ok record
          _ -> Err (ParseError "Failed to decode API response")
      else if Http.statusCode response == 429 then
        Err (RateLimitError 60)  -- Default retry after 60 seconds
      else
        Err (ApiError (Http.statusCode response) (Http.statusText response))
    catch e
      Err (NetworkError 0 ("Network exception: " Text.++ Debug.toText e))
  ```
  **Note:** Exact HTTP library API may differ - explore with:
  ```javascript
  mcp__unison__search-definitions-by-name({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    query: "Http"
  })
  ```

- [ ] **Task 2.5: Test with live API** (20 min)
  ```unison
  testLiveApi : '{IO, Exception} ()
  testLiveApi = do
    printLine "=== Testing Live API ==="

    -- Use token from PHASE1_COMPLETE.md: KtvacTziT5xqLPJS1oKO
    config = defaultApiConfig "KtvacTziT5xqLPJS1oKO"

    result = fetchCarbonIntensity config "US-NW-PGE" "2025-11-15 05:00"

    match result with
      Ok record ->
        printLine ("✓ Success: " Text.++ formatRecord record)
      Err error ->
        printLine ("✗ Error: " Text.++ PipelineError.toText error)
  ```
  **Run test:**
  ```javascript
  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testLiveApi",
    args: []
  })
  ```

- [ ] **Task 2.6: Implement withRetry** (30 min)
  ```unison
  withRetry : Nat -> Nat -> '{IO, Exception} (Result PipelineError a) -> '{IO, Exception} (Result PipelineError a)
  withRetry maxAttempts backoffMs action = do
    retryLoop : Nat -> '{IO, Exception} (Result PipelineError a)
    retryLoop attempt = do
      if attempt >= maxAttempts then
        action()
      else
        result = action()
        match result with
          Ok value -> Ok value
          Err (RateLimitError seconds) ->
            -- Honor rate limit, wait and retry
            sleep (seconds * 1000)
            retryLoop (attempt + 1)
          Err (NetworkError _ _) ->
            -- Transient error, backoff and retry
            sleep (backoffMs * (2 ^ attempt))  -- Exponential backoff
            retryLoop (attempt + 1)
          Err other ->
            -- Non-retryable error
            Err other

    retryLoop 0
  ```

- [ ] **Task 2.7: Implement fetchCurrentIntensity** (15 min)
  ```unison
  fetchCurrentIntensity : ApiConfig -> Text -> '{IO, Exception} (Result PipelineError CarbonIntensityRecord)
  fetchCurrentIntensity config zone = do
    -- Get current timestamp
    currentTime = now()
    timestamp = formatTimestamp currentTime  -- ISO 8601 format

    -- Fetch with retry
    withRetry config.retryAttempts config.retryBackoff do
      fetchCarbonIntensity config zone timestamp
  ```

- [ ] **Task 2.8: Test error handling** (20 min)
  ```unison
  testApiErrors : '{IO, Exception} ()
  testApiErrors = do
    printLine "=== Testing API Error Handling ==="

    config = defaultApiConfig "test-token"

    -- Test invalid zone
    result1 = fetchCarbonIntensity config "INVALID-ZONE" "2025-11-15 05:00"
    match result1 with
      Err _ -> printLine "✓ Invalid zone handled"
      Ok _ -> printLine "✗ Should have errored on invalid zone"

    -- Test invalid timestamp
    result2 = fetchCarbonIntensity config "US-NW-PGE" "invalid-timestamp"
    match result2 with
      Err _ -> printLine "✓ Invalid timestamp handled"
      Ok _ -> printLine "✗ Should have errored on invalid timestamp"
  ```

- [ ] **Task 2.9: Implement fetchTimeRange (optional, nice-to-have)** (30 min)
  ```unison
  fetchTimeRange : ApiConfig -> Text -> [Text] -> '{IO, Exception} (Result PipelineError [CarbonIntensityRecord])
  fetchTimeRange config zone timestamps = do
    results = List.map
      (ts -> fetchCarbonIntensity config zone ts)
      timestamps

    -- Collect results, stop on first error
    sequence : [Result e a] -> Result e [a]
    sequence results =
      List.foldLeft
        (acc r -> Result.flatMap (list -> Result.map (x -> list List.++ [x]) r) acc)
        (Ok [])
        results

    sequence results
  ```

- [ ] **Task 2.10: Final verification** (15 min)
  **Typecheck:**
  ```javascript
  mcp__unison__typecheck-code({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    code: {filePath: "/workspace/api.u"}
  })
  ```

  **Run all tests:**
  ```javascript
  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testLiveApi",
    args: []
  })

  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testApiErrors",
    args: []
  })
  ```

**Verification Complete When:**
- ✅ All 10 tasks checked off
- ✅ File typechecks with no errors
- ✅ Live API test succeeds (returns carbon data)
- ✅ Error handling test catches invalid inputs
- ✅ Retry logic tested (at least manually verified)

**Handoff to Next Workstream:**
```unison
-- WORKSTREAM 2 COMPLETE - Ready for Workstream 4 (Pipeline)
-- API client functional with Electricity Maps
-- Retry logic with exponential backoff implemented
-- Error handling for network, rate limits, and API errors
-- Dependencies: Workstream 3 (cache) also needed for pipeline
```

---

#### Workstream 3: In-Memory Cache
**File:** `cache.u` (NEW)
**Estimated Time:** 3-4 hours
**Dependencies:** Workstream 1 (errors.u) must be complete
**Parallel:** Can work alongside Workstream 2 (api.u)

**Atomic Task Checklist:**

- [ ] **Task 3.1: Create cache.u and define types** (20 min)
  ```unison
  -- cache.u
  -- Phase 2: In-memory cache for carbon intensity data

  use .base
  use .carbonIntensity
  use .errors

  type CacheEntry =
    { record : CarbonIntensityRecord
    , fetchedAt : Nat  -- Unix timestamp
    }

  type DataCache =
    { maxAge : Nat  -- seconds
    , maxSize : Nat  -- entries per zone
    , data : Map Text [CacheEntry]  -- Key: zone
    }
  ```

- [ ] **Task 3.2: Implement Cache.empty** (10 min)
  ```unison
  Cache.empty : Nat -> Nat -> DataCache
  Cache.empty maxAge maxSize =
    DataCache maxAge maxSize Map.empty
  ```

- [ ] **Task 3.3: Implement Cache.add** (30 min)
  ```unison
  Cache.add : DataCache -> Text -> CarbonIntensityRecord -> Nat -> DataCache
  Cache.add cache zone record timestamp =
    entry = CacheEntry record timestamp
    entries = Map.getOrElse zone [] cache.data

    -- Add new entry
    newEntries = List.cons entry entries
      |> List.sortBy (e -> e.fetchedAt) -- Sort by timestamp
      |> List.reverse  -- Newest first
      |> List.take cache.maxSize  -- Enforce size limit

    DataCache cache.maxAge cache.maxSize (Map.insert zone newEntries cache.data)
  ```

- [ ] **Task 3.4: Implement Cache.get** (25 min)
  ```unison
  Cache.get : DataCache -> Text -> Nat -> Nat -> Optional CarbonIntensityRecord
  Cache.get cache zone requestedTime currentTime =
    entries = Map.get zone cache.data |> Optional.orElse []

    -- Find entry matching timestamp (within tolerance)
    tolerance = 300  -- 5 minutes

    List.find
      (e ->
        age = currentTime - e.fetchedAt
        timeDiff = if e.fetchedAt > requestedTime
                   then e.fetchedAt - requestedTime
                   else requestedTime - e.fetchedAt
        Boolean.and (age < cache.maxAge) (timeDiff < tolerance))
      entries
      |> Optional.map (e -> e.record)
  ```

- [ ] **Task 3.5: Implement Cache.getRecent** (20 min)
  ```unison
  Cache.getRecent : DataCache -> Text -> Nat -> Nat -> [CarbonIntensityRecord]
  Cache.getRecent cache zone count currentTime =
    entries = Map.get zone cache.data |> Optional.orElse []

    entries
      |> List.filter (e -> (currentTime - e.fetchedAt) < cache.maxAge)
      |> List.take count
      |> List.map (e -> e.record)
  ```

- [ ] **Task 3.6: Implement Cache.evict** (20 min)
  ```unison
  Cache.evict : DataCache -> Nat -> DataCache
  Cache.evict cache currentTime =
    evictZone : Text -> [CacheEntry] -> [CacheEntry]
    evictZone zone entries =
      List.filter (e -> (currentTime - e.fetchedAt) < cache.maxAge) entries

    newData = Map.mapValues evictZone cache.data
    DataCache cache.maxAge cache.maxSize newData
  ```

- [ ] **Task 3.7: Implement fetchWithCache** (30 min)
  ```unison
  fetchWithCache : DataCache -> ApiConfig -> Text -> Text -> Nat -> '{IO, Exception} (Result PipelineError (CarbonIntensityRecord, DataCache))
  fetchWithCache cache config zone timestamp currentTime = do
    -- Check cache first
    match Cache.get cache zone (parseTimestamp timestamp) currentTime with
      Some record ->
        printLine ("Cache HIT for " Text.++ zone)
        Ok (record, cache)

      None -> do
        printLine ("Cache MISS for " Text.++ zone)
        -- Fetch from API
        result = fetchCarbonIntensity config zone timestamp

        match result with
          Ok record ->
            -- Add to cache
            newCache = Cache.add cache zone record currentTime
            Ok (record, newCache)
          Err error ->
            Err error
  ```

- [ ] **Task 3.8: Create cache tests** (30 min)
  ```unison
  testCacheOperations : '{IO, Exception} ()
  testCacheOperations = do
    printLine "=== Testing Cache Operations ==="

    cache = Cache.empty 86400 100  -- 24 hours, 100 entries

    -- Test add and get
    cache2 = Cache.add cache "US-NW-PGE" sampleRecord 1000
    match Cache.get cache2 "US-NW-PGE" 1000 1100 with
      Some r -> printLine "✓ Cache add/get working"
      None -> printLine "✗ Cache get failed"

    -- Test size limit
    cache3 = List.foldLeft
      (c i -> Cache.add c "US-NW-PGE" sampleRecord (1000 + i))
      cache
      (List.range 0 150)

    entries = Cache.getRecent cache3 "US-NW-PGE" 150 2000
    if List.size entries <= 100 then
      printLine "✓ Size limit enforced"
    else
      printLine "✗ Size limit not working"

    -- Test eviction
    cache4 = Cache.evict cache2 90000  -- Evict old entries
    printLine "✓ Eviction complete"
  ```

- [ ] **Task 3.9: Test cache integration with API** (20 min)
  ```unison
  testCacheIntegration : '{IO, Exception} ()
  testCacheIntegration = do
    printLine "=== Testing Cache Integration ==="

    cache = Cache.empty 86400 100
    config = defaultApiConfig "KtvacTziT5xqLPJS1oKO"

    -- First fetch - cache miss
    result1 = fetchWithCache cache config "US-NW-PGE" "2025-11-15 05:00" (now())
    match result1 with
      Ok (record, cache2) ->
        printLine "✓ First fetch successful (cache miss)"

        -- Second fetch - cache hit
        result2 = fetchWithCache cache2 config "US-NW-PGE" "2025-11-15 05:00" (now())
        match result2 with
          Ok (record2, cache3) ->
            printLine "✓ Second fetch successful (should be cache hit)"
          Err e ->
            printLine ("✗ Second fetch failed: " Text.++ PipelineError.toText e)

      Err e ->
        printLine ("✗ First fetch failed: " Text.++ PipelineError.toText e)
  ```

- [ ] **Task 3.10: Final verification** (10 min)
  ```javascript
  // Typecheck
  mcp__unison__typecheck-code({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    code: {filePath: "/workspace/cache.u"}
  })

  // Run tests
  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testCacheOperations",
    args: []
  })

  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testCacheIntegration",
    args: []
  })
  ```

**Verification Complete When:**
- ✅ All 10 tasks checked off
- ✅ Cache operations (add/get/evict) working
- ✅ Size limits enforced
- ✅ Expiry logic works
- ✅ Cache integration reduces API calls

**Handoff:**
```unison
-- WORKSTREAM 3 COMPLETE - Ready for Workstream 4 (Pipeline)
-- In-memory cache functional with LRU and time-based eviction
-- Cache-aware fetching reduces API calls
-- Dependencies: Needs Workstream 2 (API) for full integration
```

---

#### Workstream 4: Pipeline Composition
**File:** `pipeline.u` (NEW)
**Estimated Time:** 2-3 hours
**Dependencies:** Workstreams 1, 2, 3 must be complete
**Parallel:** No (requires previous workstreams)

**Quick Reference:**
```javascript
// Check dependencies before starting
mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "Result"
})  // From Workstream 1

mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "fetchCarbonIntensity"
})  // From Workstream 2

mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "DataCache"
})  // From Workstream 3
```

**Atomic Task Checklist:**

- [ ] **Task 4.1: Create pipeline.u with operators** (30 min)
  ```unison
  -- pipeline.u
  -- Phase 2: Pipeline composition and validation

  use .base
  use .carbonIntensity
  use .errors

  -- Pipeline operator (alias for Result.flatMap)
  (|>) : Result e a -> (a -> Result e b) -> Result e b
  (|>) = Result.flatMap

  -- Helper: validate with predicate
  validate : (a -> Boolean) -> Text -> a -> Result PipelineError a
  validate predicate errorMsg value =
    if predicate value then Ok value
    else Err (ValidationError errorMsg)
  ```

- [ ] **Task 4.2: Implement validation functions** (30 min)
  ```unison
  validateZone : Text -> Result PipelineError Text
  validateZone zone =
    validate (z -> Boolean.not (Text.isEmpty z)) "Zone cannot be empty" zone

  validateTimestamp : Text -> Result PipelineError Text
  validateTimestamp timestamp =
    -- Basic ISO 8601 check
    validate
      (ts -> Text.contains "-" ts Boolean.and Text.contains ":" ts)
      "Invalid timestamp format"
      timestamp

  validateRecord : CarbonIntensityRecord -> Result PipelineError CarbonIntensityRecord
  validateRecord record =
    carbon = getCarbonIntensity record
    validate
      (r -> Boolean.and (carbon > 0) (carbon < 10000))
      "Carbon intensity out of reasonable range"
      record
  ```

- [ ] **Task 4.3: Implement carbonPipeline** (45 min)
  ```unison
  carbonPipeline : DataCache -> ApiConfig -> Text -> Text -> Nat
                -> '{IO, Exception} (Result PipelineError (CarbonIntensityRecord, DataCache))
  carbonPipeline cache config zone timestamp currentTime = do
    -- Pipeline: validate → fetch (with cache) → validate record
    result =
      validateZone zone
        |> (\z -> validateTimestamp timestamp |> Result.map (\_ -> z))
        |> (\z -> fetchWithCache cache config z timestamp currentTime)
        |> Result.flatMap (\(record, newCache) ->
            validateRecord record
              |> Result.map (\r -> (r, newCache)))

    result
  ```

- [ ] **Task 4.4: Create pipeline tests** (30 min)
  ```unison
  testPipelineSuccess : '{IO, Exception} ()
  testPipelineSuccess = do
    printLine "=== Testing Pipeline Success Case ==="

    cache = Cache.empty 86400 100
    config = defaultApiConfig "KtvacTziT5xqLPJS1oKO"

    result = carbonPipeline cache config "US-NW-PGE" "2025-11-15 05:00" (now())

    match result with
      Ok (record, cache2) ->
        printLine ("✓ Pipeline succeeded: " Text.++ formatRecord record)
      Err error ->
        printLine ("✗ Pipeline failed: " Text.++ PipelineError.toText error)

  testPipelineValidation : '{IO, Exception} ()
  testPipelineValidation = do
    printLine "=== Testing Pipeline Validation ==="

    cache = Cache.empty 86400 100
    config = defaultApiConfig "test-token"

    -- Test empty zone
    result1 = carbonPipeline cache config "" "2025-11-15 05:00" (now())
    match result1 with
      Err (ValidationError msg) -> printLine ("✓ Empty zone caught: " Text.++ msg)
      _ -> printLine "✗ Should have failed on empty zone"

    -- Test invalid timestamp
    result2 = carbonPipeline cache config "US-NW-PGE" "invalid" (now())
    match result2 with
      Err (ValidationError msg) -> printLine ("✓ Invalid timestamp caught: " Text.++ msg)
      _ -> printLine "✗ Should have failed on invalid timestamp"
  ```

- [ ] **Task 4.5: Final verification** (15 min)
  ```javascript
  mcp__unison__typecheck-code({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    code: {filePath: "/workspace/pipeline.u"}
  })

  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testPipelineSuccess",
    args: []
  })

  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testPipelineValidation",
    args: []
  })
  ```

**Verification Complete When:**
- ✅ Pipeline operators working (|> combinator)
- ✅ Validation catches invalid inputs
- ✅ Full pipeline integrates all previous workstreams
- ✅ Error messages are clear and actionable

**Handoff:**
```unison
-- WORKSTREAM 4 COMPLETE - Ready for Workstream 5 (Optimizer)
-- Pipeline composition functional with validation
-- Integrates API client and cache seamlessly
```

---

#### Workstream 5: Decision Engine
**File:** `optimizer.u` (NEW)
**Estimated Time:** 3-4 hours
**Dependencies:** Workstream 4 (pipeline.u) must be complete
**Parallel:** No (builds on pipeline)

**Atomic Task Checklist:**

- [ ] **Task 5.1: Create optimizer.u with decision types** (20 min)
  ```unison
  -- optimizer.u
  -- Phase 2: Carbon-aware optimization decision engine

  use .base
  use .carbonIntensity
  use .errors
  use .cache
  use .pipeline

  type OptimizationDecision
    = RunNow Text
    | Defer Nat Text
    | Skip Text

  type OptimizerConfig =
    { lowCarbonThreshold : Nat
    , maxWaitTime : Nat
    , preferredZones : [Text]
    }

  defaultOptimizerConfig : OptimizerConfig
  defaultOptimizerConfig =
    OptimizerConfig 300 3600 ["US-NW-PGE", "US-NW-PACW"]
  ```

- [ ] **Task 5.2: Implement shouldRun** (25 min)
  ```unison
  shouldRun : OptimizerConfig -> CarbonIntensityRecord -> OptimizationDecision
  shouldRun config record =
    carbon = getCarbonIntensity record

    if carbon <= config.lowCarbonThreshold then
      RunNow ("Carbon intensity is low: " Text.++ Nat.toText carbon Text.++ " gCO2eq/kWh")
    else if carbon <= (config.lowCarbonThreshold + 100) then
      Defer 1800 ("Carbon slightly elevated: " Text.++ Nat.toText carbon Text.++ ". Wait 30 minutes")
    else if carbon <= (config.lowCarbonThreshold + 300) then
      Defer 3600 ("Carbon moderately high: " Text.++ Nat.toText carbon Text.++ ". Wait 1 hour")
    else
      Skip ("Carbon too high: " Text.++ Nat.toText carbon Text.++ " gCO2eq/kWh. Skip for now")
  ```

- [ ] **Task 5.3: Implement bestZone** (30 min)
  ```unison
  bestZone : OptimizerConfig -> [(Text, CarbonIntensityRecord)] -> Optional (Text, CarbonIntensityRecord)
  bestZone config zoneRecords =
    if List.isEmpty zoneRecords then None
    else
      -- Find zone with lowest carbon
      sorted = List.sortBy
        (\(zone, record) -> getCarbonIntensity record)
        zoneRecords

      -- Prefer preferred zones if within 10% of best
      best = List.head sorted |> Optional.map (\(z, r) -> getCarbonIntensity r) |> Optional.getOrElse 1000
      threshold = best + (best / 10)

      -- Check if any preferred zone is within threshold
      preferredMatch = List.find
        (\(zone, record) ->
          isPreferred = List.contains zone config.preferredZones
          withinThreshold = getCarbonIntensity record <= threshold
          Boolean.and isPreferred withinThreshold)
        sorted

      Optional.orElse (List.head sorted) preferredMatch
  ```

- [ ] **Task 5.4: Implement estimateWaitTime (optional)** (30 min)
  ```unison
  estimateWaitTime : OptimizerConfig -> DataCache -> Text -> Nat -> Optional Nat
  estimateWaitTime config cache zone currentTime =
    recent = Cache.getRecent cache zone 10 currentTime

    if List.size recent < 3 then None
    else
      -- Calculate average rate of change
      values = List.map getCarbonIntensity recent
      avgCarbon = List.sum values / List.size values

      if avgCarbon <= config.lowCarbonThreshold then
        Some 0  -- Already low
      else
        -- Rough estimate: assume linear trend continues
        latest = List.head recent |> Optional.map getCarbonIntensity |> Optional.getOrElse avgCarbon
        oldest = List.last recent |> Optional.map getCarbonIntensity |> Optional.getOrElse avgCarbon

        if oldest > latest then
          -- Carbon decreasing, estimate time to threshold
          rate = (oldest - latest) / List.size recent  -- gCO2eq per measurement
          remaining = latest - config.lowCarbonThreshold
          Some (remaining / rate * 300)  -- Assume 5 min per measurement
        else
          None  -- Carbon increasing, can't estimate
  ```

- [ ] **Task 5.5: Implement optimizeWorkload** (45 min)
  ```unison
  optimizeWorkload : OptimizerConfig -> DataCache -> ApiConfig -> [Text] -> Nat
                  -> '{IO, Exception} (Result PipelineError (OptimizationDecision, Text, DataCache))
  optimizeWorkload config cache apiConfig zones currentTime = do
    -- Fetch current carbon for all zones
    results = List.map
      (\zone -> do
        result = carbonPipeline cache apiConfig zone (formatTimestamp currentTime) currentTime
        (zone, result))
      zones

    -- Collect successful results
    successes = List.filterMap
      (\(zone, result) -> match result with
        Ok (record, _) -> Some (zone, record)
        Err _ -> None)
      results

    -- Find best zone
    match bestZone config successes with
      Some (zone, record) ->
        decision = shouldRun config record
        -- Update cache with results from best zone
        finalCache = cache  -- Would update with all fetched data
        Ok (decision, zone, finalCache)

      None ->
        Err (ApiError 0 "Failed to fetch carbon data from any zone")
  ```

- [ ] **Task 5.6: Create optimizer tests** (30 min)
  ```unison
  testOptimizationDecisions : '{IO, Exception} ()
  testOptimizationDecisions = do
    printLine "=== Testing Optimization Decisions ==="

    config = defaultOptimizerConfig

    -- Test low carbon → RunNow
    lowRecord = CarbonIntensityRecord "TEST" 250 "2025-11-15" false None
    match shouldRun config lowRecord with
      RunNow reason -> printLine ("✓ Low carbon (250): " Text.++ reason)
      _ -> printLine "✗ Should have decided RunNow"

    -- Test high carbon → Defer
    highRecord = CarbonIntensityRecord "TEST" 450 "2025-11-15" false None
    match shouldRun config highRecord with
      Defer seconds reason -> printLine ("✓ High carbon (450): Defer " Text.++ Nat.toText seconds Text.++ "s")
      _ -> printLine "✗ Should have decided Defer"

    -- Test very high carbon → Skip
    veryHighRecord = CarbonIntensityRecord "TEST" 800 "2025-11-15" false None
    match shouldRun config veryHighRecord with
      Skip reason -> printLine ("✓ Very high carbon (800): " Text.++ reason)
      _ -> printLine "✗ Should have decided Skip"

  testMultiZoneOptimization : '{IO, Exception} ()
  testMultiZoneOptimization = do
    printLine "=== Testing Multi-Zone Optimization ==="

    cache = Cache.empty 86400 100
    config = defaultOptimizerConfig
    apiConfig = defaultApiConfig "KtvacTziT5xqLPJS1oKO"

    zones = ["US-NW-PGE", "US-NW-PACW", "US-CAL-CISO"]

    result = optimizeWorkload config cache apiConfig zones (now())

    match result with
      Ok (decision, zone, newCache) -> do
        printLine ("✓ Best zone: " Text.++ zone)
        match decision with
          RunNow reason -> printLine ("  Decision: " Text.++ reason)
          Defer seconds reason -> printLine ("  Decision: Defer " Text.++ Nat.toText seconds Text.++ "s - " Text.++ reason)
          Skip reason -> printLine ("  Decision: " Text.++ reason)

      Err error ->
        printLine ("✗ Optimization failed: " Text.++ PipelineError.toText error)
  ```

- [ ] **Task 5.7: Final verification** (15 min)
  ```javascript
  mcp__unison__typecheck-code({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    code: {filePath: "/workspace/optimizer.u"}
  })

  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testOptimizationDecisions",
    args: []
  })

  mcp__unison__run({
    projectContext: {projectName: "carbon-pipeline", branchName: "main"},
    mainFunctionName: "testMultiZoneOptimization",
    args: []
  })
  ```

**Verification Complete When:**
- ✅ Decision logic works for all carbon ranges
- ✅ bestZone selects optimal zone
- ✅ Multi-zone optimization completes successfully
- ✅ Decisions are actionable and explained

**Handoff:**
```unison
-- WORKSTREAM 5 COMPLETE - Ready for Workstream 6 (Integration Tests)
-- Optimization engine functional with real-time decisions
-- Multi-zone comparison and carbon-aware scheduling working
```

---

## Progress Tracking

### Workstream Status Checklist

**Use this to track Phase 2 implementation progress:**

```
FOUNDATION (Week 1)
[ ] Workstream 1: Error Handling (errors.u)
    - Dependencies: None
    - Estimated: 2-3 hours
    - Key deliverable: Result type and PipelineError

[ ] Workstream 2: API Client (api.u)
    - Dependencies: Workstream 1
    - Estimated: 4-6 hours
    - Key deliverable: fetchCarbonIntensity function

[ ] Workstream 3: In-Memory Cache (cache.u)
    - Dependencies: Workstream 1
    - Estimated: 3-4 hours
    - Key deliverable: DataCache and fetchWithCache

COMPOSITION (Week 2-3)
[ ] Workstream 4: Pipeline Composition (pipeline.u)
    - Dependencies: Workstreams 1, 2, 3
    - Estimated: 2-3 hours
    - Key deliverable: carbonPipeline function

[ ] Workstream 5: Decision Engine (optimizer.u)
    - Dependencies: Workstream 4
    - Estimated: 3-4 hours
    - Key deliverable: optimizeWorkload function

VALIDATION (Week 3)
[ ] Workstream 6: Integration Tests (integration.u)
    - Dependencies: Workstreams 1-5
    - Estimated: 4-5 hours
    - Key deliverable: runPhase2Tests function

DOCUMENTATION (Week 4)
[ ] Workstream 7: Documentation (PHASE2_COMPLETE.md, README.md, CLAUDE.md)
    - Dependencies: Workstream 6
    - Estimated: 3-4 hours
    - Key deliverable: Complete Phase 2 documentation

[ ] Workstream 8: Phase 3 Planning (PHASE3_PLAN.md)
    - Dependencies: Workstream 7
    - Estimated: 2-3 hours
    - Key deliverable: Actionable Phase 3 roadmap
```

### Quick Status Check Commands

**Run these to see what's been completed:**

```javascript
// List all definitions (look for Phase 2 types/functions)
mcp__unison__list-project-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"}
})

// Check for specific workstream completion
// Workstream 1: Look for "Result", "PipelineError"
// Workstream 2: Look for "fetchCarbonIntensity", "ApiConfig"
// Workstream 3: Look for "DataCache", "Cache.add"
// Workstream 4: Look for "carbonPipeline"
// Workstream 5: Look for "optimizeWorkload", "OptimizationDecision"
// Workstream 6: Look for "runPhase2Tests"

// Search for a specific definition
mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "SEARCH_TERM"
})
```

### Definition Count Milestone

- **Phase 1 Complete**: 38 definitions
- **After Workstream 1**: ~45 definitions (+7: Result + PipelineError + combinators)
- **After Workstream 2**: ~55 definitions (+10: API functions)
- **After Workstream 3**: ~65 definitions (+10: Cache operations)
- **After Workstream 4**: ~70 definitions (+5: Pipeline stages)
- **After Workstream 5**: ~80 definitions (+10: Optimizer functions)
- **After Workstream 6**: ~90 definitions (+10: Test functions)
- **Phase 2 Target**: ~90 definitions total

---

### QA Engineer (Testing & Validation)

#### Workstream 6: Integration Tests
**File:** `integration.u` (NEW)

**Tasks:**
1. Create test helpers:
   ```unison
   -- Mock API for testing without network
   mockApi : Zone -> Timestamp -> Result PipelineError CarbonIntensityRecord

   -- Sample configs for testing
   testApiConfig : ApiConfig
   testOptimizerConfig : OptimizerConfig

   -- Assertion helpers
   assertOk : Text -> Result e a -> '{IO, Exception} a
   assertErr : Text -> Result e a -> '{IO, Exception} e
   ```

2. Implement API integration tests:
   - `testLiveApiFetch : '{IO, Exception} ()`
     - Fetch real data from Electricity Maps API
     - Verify response structure
     - Print results

   - `testApiErrorHandling : '{IO, Exception} ()`
     - Test invalid zone (expect error)
     - Test invalid timestamp (expect error)
     - Test network failure handling

   - `testApiRateLimit : '{IO, Exception} ()`
     - Test retry logic
     - Verify backoff behavior
     - (May need to mock to avoid actual rate limits)

3. Implement cache tests:
   - `testCacheOperations : '{IO, Exception} ()`
     - Test add/get/evict
     - Verify size limits
     - Verify expiry logic

   - `testCacheIntegration : '{IO, Exception} ()`
     - Test cache-aware fetching
     - Verify cache reduces API calls
     - Test with multiple zones

4. Implement pipeline tests:
   - `testPipelineSuccess : '{IO, Exception} ()`
     - Valid inputs → successful result
     - Verify data flows correctly

   - `testPipelineValidation : '{IO, Exception} ()`
     - Invalid zone → validation error
     - Invalid timestamp → validation error
     - Invalid record → validation error

   - `testPipelineErrorPropagation : '{IO, Exception} ()`
     - Error at each stage → proper error
     - Verify error messages

5. Implement optimization tests:
   - `testOptimizationDecisions : '{IO, Exception} ()`
     - Low carbon → RunNow
     - High carbon → Defer or Skip
     - Verify decision logic

   - `testMultiZoneOptimization : '{IO, Exception} ()`
     - Fetch from multiple zones
     - Verify best zone selection
     - Test with different scenarios

6. Create master test runner:
   ```unison
   runPhase2Tests : '{IO, Exception} ()
   runPhase2Tests = do
     printLine "=== Phase 2 Integration Tests ==="
     testLiveApiFetch()
     testApiErrorHandling()
     testCacheOperations()
     testCacheIntegration()
     testPipelineSuccess()
     testPipelineValidation()
     testOptimizationDecisions()
     testMultiZoneOptimization()
     printLine "✓ All Phase 2 tests complete"
   ```

**Test Data Files:**
Create `data/test_api_responses/` with sample API responses for offline testing

**Verification:**
- All tests pass with mock data
- All tests pass with live API (when available)
- Error cases produce clear messages
- Test coverage for all new functions

---

### Architect (Oversight & Documentation)

#### Workstream 7: Documentation & Examples
**Files:** `PHASE2_COMPLETE.md` (NEW), Update `README.md`, Update `CLAUDE.md`

**Tasks:**
1. Create `PHASE2_COMPLETE.md`:
   - Architecture overview diagram
   - API integration guide
   - Cache strategy explanation
   - Example usage scenarios
   - Error handling patterns
   - Testing instructions
   - Known limitations
   - Phase 3 migration path

2. Update `README.md`:
   - Add Phase 2 status
   - Update "Getting Started" with API examples
   - Document new functions
   - Add real-time optimization examples

3. Update `CLAUDE.md`:
   - Add Phase 2 MCP workflow
   - Document new modules
   - Update development commands
   - Add troubleshooting section

4. Create usage examples:
   ```unison
   -- Example 1: Simple optimization decision
   exampleSimpleOptimization : '{IO, Exception} ()

   -- Example 2: Multi-zone optimization
   exampleMultiZoneOptimization : '{IO, Exception} ()

   -- Example 3: Trend analysis from cache
   exampleTrendAnalysis : '{IO, Exception} ()
   ```

5. Document configuration:
   - API credentials setup
   - Rate limit guidelines
   - Cache sizing recommendations
   - Optimizer threshold tuning

**Verification:**
- Documentation is clear and complete
- Examples run successfully
- No broken links or references
- README accurately reflects Phase 2 state

---

#### Workstream 8: Architecture Review & Phase 3 Planning
**Files:** `PHASE3_PLAN.md` (NEW)

**Tasks:**
1. Review Phase 2 implementation:
   - Identify patterns that worked well
   - Document pain points
   - Note technical debt
   - Measure API usage and cache hit rates

2. Plan Phase 3 architecture:
   - Document storage requirements learned from Phase 2
   - Design Volturno KLog integration
   - Plan migration from in-memory to persistent
   - Design backward compatibility strategy

3. Create `PHASE3_PLAN.md`:
   - Phase 3 goals and scope
   - Volturno KLog integration approach
   - Data migration strategy
   - Distributed processing design
   - Timeline and milestones

4. Document trade-offs:
   - In-memory vs persistent
   - Real-time vs batch
   - API polling vs streaming
   - Single-node vs distributed

**Verification:**
- Phase 3 plan is actionable
- Migration path is clear
- Technical debt is documented
- Lessons learned captured

---

## Critical Files

### Files to Create (Phase 2)
1. **`/workspace/errors.u`** - Error types and Result helpers (Workstream 1)
2. **`/workspace/api.u`** - Electricity Maps API client (Workstream 2)
3. **`/workspace/cache.u`** - In-memory cache implementation (Workstream 3)
4. **`/workspace/pipeline.u`** - Pipeline composition (Workstream 4)
5. **`/workspace/optimizer.u`** - Decision engine (Workstream 5)
6. **`/workspace/integration.u`** - Integration tests (Workstream 6)
7. **`/workspace/PHASE2_COMPLETE.md`** - Documentation (Workstream 7)

### Files to Enhance (Phase 1)
- **`/workspace/aggregations.u`** - Add validation functions (minor)
- **`/workspace/README.md`** - Update with Phase 2 info
- **`/workspace/CLAUDE.md`** - Update development guide

### Files to Reference (Phase 1)
- **`/workspace/carbonIntensity.u`** - Core types (no changes)
- **`/workspace/cleanDecoder.u`** - Decoder (no changes)

---

## Implementation Sequence

### Week 1: Foundation (Days 1-3)
**Goal:** Error handling + API client working

**Day 1:**
- Senior Dev: Create `errors.u` with Result type and combinators
- QA: Set up test infrastructure, create mock API

**Day 2:**
- Senior Dev: Install `@unison/http`, create `api.u` with basic fetch
- QA: Test API with real Electricity Maps endpoint

**Day 3:**
- Senior Dev: Add retry logic and error handling to API
- QA: Test error cases and rate limiting
- Architect: Review API design, document patterns

**Checkpoint:** Can fetch live carbon intensity data with proper error handling

---

### Week 2: Cache + Pipeline (Days 4-6)
**Goal:** In-memory cache and pipeline composition working

**Day 4:**
- Senior Dev: Create `cache.u` with add/get/evict operations
- QA: Create cache operation tests

**Day 5:**
- Senior Dev: Implement cache-aware fetching
- QA: Test cache hit rates and expiry

**Day 6:**
- Senior Dev: Create `pipeline.u` with stage composition
- QA: Test pipeline with valid/invalid inputs
- Architect: Review cache strategy, document trade-offs

**Checkpoint:** Can fetch data with caching, reducing API calls

---

### Week 3: Optimization + Testing (Days 7-9)
**Goal:** Decision engine and comprehensive tests

**Day 7:**
- Senior Dev: Create `optimizer.u` with decision logic
- QA: Create optimization test scenarios

**Day 8:**
- Senior Dev: Implement multi-zone optimization
- QA: Create `integration.u` with all tests

**Day 9:**
- Senior Dev: Polish and bug fixes
- QA: Run full test suite, document results
- Architect: Review complete implementation

**Checkpoint:** All tests passing, optimization decisions working

---

### Week 4: Documentation + Handoff (Days 10-12)
**Goal:** Complete documentation and Phase 3 planning

**Day 10:**
- Architect: Create `PHASE2_COMPLETE.md` with examples
- QA: Validate all examples work

**Day 11:**
- Architect: Update `README.md` and `CLAUDE.md`
- Senior Dev: Create usage examples

**Day 12:**
- Architect: Create `PHASE3_PLAN.md`
- Team: Review Phase 2 completion, plan Phase 3 kickoff

**Checkpoint:** Phase 2 complete and documented

---

## End-to-End Verification

### Manual Testing Sequence
```bash
# 1. Install required library
# Use MCP tool: mcp__unison__lib-install
# Library: @unison/http

# 2. Typecheck all new files
# Use MCP: mcp__unison__typecheck-code for each .u file

# 3. Run integration tests
# Use MCP: mcp__unison__run
# Function: runPhase2Tests

# 4. Test live optimization
# Use MCP: mcp__unison__run
# Function: exampleSimpleOptimization
```

### Expected Outputs
```
=== Phase 2 Integration Tests ===

Testing Live API Fetch...
✓ Fetched carbon intensity for US-NW-PGE: 342 gCO2eq/kWh

Testing API Error Handling...
✓ Invalid zone handled correctly
✓ Network error handled correctly

Testing Cache Operations...
✓ Cache add/get working
✓ Cache eviction working
✓ Cache size limit enforced

Testing Cache Integration...
✓ Cache hit reduces API calls
✓ Cache miss fetches from API

Testing Pipeline...
✓ Valid input → success
✓ Invalid zone → validation error
✓ Invalid timestamp → validation error

Testing Optimization Decisions...
✓ Low carbon (250) → RunNow
✓ High carbon (650) → Defer 3600s
✓ Very high carbon (1000) → Skip

Testing Multi-Zone Optimization...
✓ Best zone selected: US-NW-PACW (220 gCO2eq/kWh)
✓ Decision: RunNow in US-NW-PACW

✓ All Phase 2 tests complete
```

---

## Success Criteria

### Must Have (Required for Phase 2 Completion)
- ✅ `Result` type and error handling working
- ✅ Electricity Maps API integration functional
- ✅ In-memory cache reduces API calls
- ✅ Pipeline composition with validation stages
- ✅ Optimization decision engine working
- ✅ Multi-zone comparison and selection
- ✅ Retry logic with exponential backoff
- ✅ Comprehensive integration tests passing
- ✅ Documentation complete (`PHASE2_COMPLETE.md`)
- ✅ All Phase 1 tests still passing

### Nice to Have (Enhancements)
- ⭐ Trend estimation from cache data
- ⭐ Rate limit handling with retry-after
- ⭐ Batch fetching optimization
- ⭐ Cache statistics (hit rate, eviction count)
- ⭐ Performance metrics

### Future (Deferred to Phase 3)
- ⏭️ Persistent storage (Volturno KLog)
- ⏭️ Historical trend analysis
- ⏭️ Long-term carbon forecasting
- ⏭️ Distributed processing
- ⏭️ Data durability and recovery

---

## Risk Mitigation

### Risk: API Rate Limits
**Mitigation:**
- Implement retry with exponential backoff
- Cache aggressively (24-48 hour window)
- Batch requests when possible
- Monitor API usage

### Risk: Network Unreliability
**Mitigation:**
- Retry logic for transient failures
- Fallback to cached data when fresh fetch fails
- Clear error messages for persistent failures
- Test with mock API for offline development

### Risk: Cache Memory Usage
**Mitigation:**
- Set reasonable size limits (1000 entries per zone)
- Implement age-based eviction (24-48 hours)
- Monitor cache size in tests
- Document memory requirements

### Risk: API Costs
**Mitigation:**
- Use test/free tier for development
- Cache to minimize calls
- Document expected API usage
- Consider mock API for CI/CD

### Risk: Complex Multi-Agent Coordination
**Mitigation:**
- Clear workstream boundaries
- Well-defined interfaces between modules
- Comprehensive integration tests
- Regular check-ins (architect reviews)

---

## Phase 3 Preview

**When Phase 2 is complete, Phase 3 will add:**

1. **Persistent Storage with Volturno KLog**
   - Replace in-memory cache with KLog
   - Keyed by zone for fast lookups
   - Append-only time-series storage

2. **Streaming Processing with KStream**
   - Real-time aggregations
   - Windowed computations (hourly, daily)
   - Exactly-once processing semantics

3. **Historical Analysis**
   - Trend detection across weeks/months
   - Carbon forecasting models
   - Pattern recognition (daily cycles, seasonal trends)

4. **Distributed Processing**
   - Multi-node pipeline execution
   - Fault tolerance and recovery
   - Scalability for many zones

**Migration Path:**
- Phase 2 cache interface → Phase 3 KLog interface
- Result types and error handling carry forward
- API client reused as-is
- Optimizer enhanced with historical data
- Tests adapted for persistent storage

---

## Notes for Future Claude Code Sessions

**To Resume Phase 2 Work:**
1. Read this plan file
2. Check current project context: `mcp__unison__get-current-project-context`
3. List existing definitions: `mcp__unison__list-project-definitions`
4. Identify which workstreams are complete vs. in-progress
5. Pick up next workstream in sequence

**Key Context Files:**
- `/workspace/CLAUDE.md` - Development guide
- `/workspace/PHASE1_COMPLETE.md` - What's already done
- This plan - Phase 2 roadmap
- `/workspace/README.md` - Project overview

**API Credentials:**
- Token stored in `PHASE1_COMPLETE.md`
- Base URL: `https://api.electricitymaps.com/v3/`
- Zone: `US-NW-PGE` for testing

**Don't Forget:**
- Use MCP tools (not direct UCM) when using Claude Code
- Follow existing patterns from Phase 1
- Keep functions pure where possible
- Test incrementally as you build

---

**Phase 2 Ready to Implement** 🚀
