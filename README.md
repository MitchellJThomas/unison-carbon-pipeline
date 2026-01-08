# Unison Carbon Pipeline

A distributed data pipeline built in [Unison](https://www.unison-lang.org/) for processing grid carbon intensity data. This project demonstrates how functional, content-addressed, distributed computing can enable carbon-aware data processing.

## Overview

The Unison Carbon Pipeline processes real-time and historical carbon intensity data from the [Electricity Maps API](https://www.electricitymaps.com/) to analyze grid emissions patterns. The goal is to build a pipeline that not only processes sustainability data but is itself sustainable by scheduling computation during low-carbon periods.

### Key Features

- **Type-safe JSON parsing** with Unison's decoder combinators
- **Carbon intensity analysis** including averages, min/max, and threshold filtering
- **REPL-driven development** for interactive exploration
- **Functional data processing** with pure, composable functions
- **Carbon-aware computing patterns** (roadmap)

## Project Status

**Phase 1: Complete ✅**

- ✅ JSON parsing and decoding
- ✅ Core data types for carbon intensity records
- ✅ Aggregation functions (average, min, max, filtering)
- ✅ Integration with Electricity Maps API data
- ✅ REPL-based testing and validation

**Upcoming Phases:**
- Phase 2: Pipeline composition and Apache Iceberg integration
- Phase 3: Distributed processing
- Phase 4: Carbon-aware optimization and scheduling

## Getting Started

### Prerequisites

- [Unison](https://www.unison-lang.org/docs/quickstart/) installed
- UCM (Unison Codebase Manager) set up
- An [Electricity Maps API](https://www.electricitymaps.com/) token (optional for testing with live data)

### Installation

1. Clone the repository:
```bash
cd ~/Dev/unison-carbon-pipeline
```

2. Start the Unison Codebase Manager:
```bash
ucm
```

3. Load the codebase:
```unison
.> ls
```

### Running the Project

1. Start UCM and explore available functions:
```unison
.> find carbonIntensity
.> find aggregations
```

2. Run the aggregation tests with sample data:
```unison
.> run testAggregations
```

Example output:
```
Sample size: 5 records
Carbon values: [250, 564, 180, 420, 290]

Average: 340.8 gCO2eq/kWh
Min: 180 gCO2eq/kWh at 2025-11-15T03:00:00.000Z
Max: 564 gCO2eq/kWh at 2025-11-15T02:00:00.000Z

Low carbon readings (< 300): 3
Percentage low carbon: 60.0%
```

3. Test JSON decoding:
```unison
.> run testCleanDecoder
```

## Project Structure

```
.
├── README.md                    # This file
├── carbonIntensity.u            # Core data types and helper functions
├── cleanDecoder.u               # JSON decoder using combinators
├── aggregations.u               # Analysis functions (avg, min, max, filtering)
├── data/
│   └── electricity_maps_sample_data.json  # Sample API response
├── docs/
│   ├── project-inception-build-a-unison-sustainability-pipeline.md
│   └── programming_paradigm_match.md
├── PHASE1_COMPLETE.md          # Phase 1 completion notes
└── PHASE1_GUIDE.md             # Phase 1 implementation guide
```

## Core Components

### Data Types

```unison
type CarbonIntensityRecord =
  { zone : Text
  , carbonIntensity : Nat
  , datetime : Text
  , isEstimated : Boolean
  , estimationMethod : Optional Text
  }
```

### Key Functions

- `averageCarbonIntensity` - Calculate mean carbon intensity across readings
- `minCarbonIntensity` / `maxCarbonIntensity` - Find optimal and worst times
- `filterLowCarbon` - Identify low-carbon time windows
- `percentageLowCarbon` - Calculate percentage of readings below threshold

## Usage Examples

### Loading and Parsing Data

```unison
-- Load JSON data from file
data = !readFile "data/electricity_maps_sample_data.json"

-- Parse and decode into records
parsed = Json.parse data
decoded = Decoder.run decodeCarbonIntensity parsed
```

### Analyzing Carbon Intensity

```unison
-- Calculate average across all readings
averageCarbonIntensity records

-- Find the cleanest time to run workloads
minCarbonIntensity records

-- Count low-carbon periods (< 300 gCO2eq/kWh)
countLowCarbon 300 records
```

## Development

### REPL-Driven Workflow

Unison's development model is uniquely REPL-focused:

1. Write functions in `.u` files
2. Use `load` to bring them into UCM
3. Test interactively with `run`
4. Use `add` to persist to codebase
5. Use `update.old` to modify existing definitions

### Testing

All core functions include test harnesses that can be run in the REPL:

```unison
.> run testAggregations
.> run testCleanDecoder
```

## API Integration

This project uses the [Electricity Maps API](https://www.electricitymaps.com/) to fetch real-time carbon intensity data.

### Example API Call

```bash
curl "https://api.electricitymaps.com/v3/carbon-intensity/past?zone=US-NW-PGE&datetime=2025-11-15+05%3A02" \
  -H "auth-token: YOUR_TOKEN"
```

**Note:** The current implementation uses test mode data for development.

## Roadmap

### Phase 2: Pipeline Composition (In Progress)
- Compose parsing → cleaning → aggregation pipeline
- Add error handling and validation
- Write output to Apache Iceberg tables
- Implement time-travel queries

### Phase 3: Distribution
- Implement distributed processing across nodes
- Map-reduce style work distribution
- Fault tolerance and partial failure handling
- Performance comparison: local vs distributed

### Phase 4: Carbon-Aware Optimization
- Real-time grid carbon intensity integration
- Schedule heavy computation during low-carbon periods
- Optimize for data locality
- Measure and report pipeline carbon footprint

### Future Experiments
- Comparison with Apache Spark pipeline
- Carbon savings measurement vs traditional approaches
- Content-addressing benefits for incremental processing

## Why Unison?

This project leverages Unison's unique features:

- **Content-addressed code** - Only rerun computations when code actually changes
- **Distributed execution** - Move computation to data instead of moving data
- **Pure functions** - Easy to test, reason about, and compose
- **No serialization overhead** - Functions travel as code, not data
- **REPL-driven development** - Interactive exploration and testing

## Resources

### Unison
- [Unison Documentation](https://www.unison-lang.org/docs/)
- [Unison Cloud](https://www.unison.cloud/)
- [Unison Community Slack](https://unison-lang.org/community)

### Sustainability & Carbon Data
- [Electricity Maps API](https://www.electricitymaps.com/)
- [Green Software Foundation](https://greensoftware.foundation/)
- [AWS Sustainability Data Initiative](https://registry.opendata.aws/collab/asdi/)
- [Cloud Carbon Footprint](https://www.cloudcarbonfootprint.org/)

### Related Projects
- [WattTime API](https://www.watttime.org/)
- [Carbon Aware SDK](https://github.com/Green-Software-Foundation/carbon-aware-sdk)

## Contributing

This is a learning project exploring Unison and carbon-aware computing. Contributions, suggestions, and discussions are welcome!

### Areas for Contribution
- Additional aggregation functions
- Support for more grid regions
- Visualization of carbon intensity patterns
- Performance optimizations
- Documentation improvements

## License

This project is for educational and research purposes.

## Acknowledgments

- [Unison Computing](https://www.unison-computing.org/) for the Unison language
- [Electricity Maps](https://www.electricitymaps.com/) for carbon intensity data
- [Green Software Foundation](https://greensoftware.foundation/) for carbon-aware computing patterns
- [AWS Sustainability Data Initiative](https://registry.opendata.aws/collab/asdi/) for inspiration

---

**Built with Unison** - Exploring the future of distributed, functional, carbon-aware computing.
