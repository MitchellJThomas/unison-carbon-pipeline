# Phase 1: Unison REPL Exploration Guide

## What We Just Created

You now have:
- **Sample data**: `data/sample_response.json` - Real API response from Electricity Maps
- **Unison code**: `carbonIntensity.u` - Your first Unison functions!

## Working in the Unison REPL

### Step 1: Start UCM (Unison Codebase Manager)

```bash
ucm
```

You'll see the Unison prompt: `.>`

### Step 2: Load Your Code

In the UCM prompt, type:

```
.> load carbonIntensity.u
```

Unison will:
1. Parse your code
2. Type-check everything
3. Show you a "scratch file" with your definitions

### Step 3: Add to Codebase

Once loaded, add it to your codebase:

```
.> add
```

This stores your functions in Unison's content-addressed store.

### Step 4: Try Your Functions!

Now you can call your functions interactively:

```unison
-- View the sample record
> sampleRecord

-- Get just the carbon intensity value
> getCarbonIntensity sampleRecord

-- Format it nicely
> formatRecord sampleRecord

-- Check if it's low carbon
> isVeryLowCarbon sampleRecord
```

## Understanding the Code

### Type Definition
```unison
type CarbonIntensityRecord =
  { zone : Text
  , carbonIntensity : Nat
  ...
  }
```
- Defines the **structure** of our data
- Like a struct or dataclass in other languages
- Fields are strongly typed

### Function Signatures
```unison
getCarbonIntensity : CarbonIntensityRecord -> Nat
```
- Takes a `CarbonIntensityRecord`
- Returns a `Nat` (natural number)
- Type signature is separate from implementation

### Pattern: Accessors
```unison
CarbonIntensityRecord.carbonIntensity record
```
- Unison auto-generates accessors for record fields
- No need to write getters!

## Next Steps

After exploring in the REPL, we'll:
1. ✅ Parse actual JSON from the API
2. Work with lists of records
3. Write aggregation functions (average, max, etc.)
4. Read/write files with IO abilities

## Unison Quick Tips

- **Content-addressed**: Functions are stored by hash, not name
- **Pure by default**: Side effects (IO, etc.) require explicit abilities
- **REPL-driven**: Build incrementally, test everything
- **No builds**: Code is always "compiled" and ready to run

## Try This Exercise

Before moving on, try adding a new function in the REPL:

```unison
-- Calculate carbon savings vs. a baseline
carbonSavings : Nat -> CarbonIntensityRecord -> Int
carbonSavings baseline record =
  Int.fromNat baseline - Int.fromNat (CarbonIntensityRecord.carbonIntensity record)
```

See how Unison catches type errors immediately!
