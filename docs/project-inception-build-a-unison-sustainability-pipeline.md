# Unison Sustainability Data Pipeline Project

## 🌍 Project Vision

Build a distributed data pipeline in Unison that processes AWS Sustainability Data Initiative datasets, demonstrating how functional, content-addressed, distributed computing can itself be more sustainable than traditional approaches.

---

## 🎯 Project Goals

### Learning Goals
- **Unison fundamentals**: REPL-driven development, abilities, content-addressing
- **Distributed execution**: Move computation to data (vs. moving data around)
- **Functional data processing**: Compare to Spark transformations
- **Carbon-aware patterns**: Explore energy-efficient computing patterns

### Output Goals
- Process real sustainability datasets (climate, emissions, energy)
- Generate insights/visualizations about environmental impact
- Measure your pipeline's own carbon footprint
- Share learnings with Green Software Foundation community

---

## 🏗️ Architecture Sketch

```
Data Sources (S3)
    ↓
Unison Ingestion Layer
    ↓
Transformation Pipeline (distributed)
    ├─ Filter/Clean
    ├─ Aggregate
    ├─ Enrich
    └─ Analyze
    ↓
Results Aggregation
    ↓
Output (Parquet/JSON/Dashboard)
```

**Unison Advantages:**
- Transformations are pure functions (easy to test, reason about)
- Content-addressed: only rerun what changed
- Distribute processing based on data locality (carbon-aware!)
- No framework overhead (Spark JVM vs. Unison native)

---

## 📊 Primary Dataset: Grid Carbon Intensity

**The Meta Play:** Use grid carbon intensity data to make your pipeline carbon-aware while processing that same data.

### Data Sources:
1. **WattTime API** - Real-time grid emissions (via AWS SDI or direct)
2. **Electricity Maps** - Global carbon intensity data
3. **EIA (Energy Information Administration)** - US grid data
4. **ENTSO-E** - European grid data

### What You'll Build:
- Ingest historical grid carbon intensity data
- Store in **Iceberg tables** (time travel = query "what was grid intensity at 3pm yesterday?")
- Use that data to schedule your own pipeline's heavy processing during low-carbon periods
- Measure carbon saved vs. "run anytime" approach

**Why Iceberg fits perfectly:**
- Time travel: "Show me grid intensity when this pipeline ran"
- Schema evolution: Add new regions/metrics without breaking queries
- ACID transactions: Consistent views of changing data
- Snapshots: Compare carbon patterns across time periods

---

## 🛠️ Implementation Phases

### Phase 1: Local REPL Exploration (Week 1)
**Goal:** Get comfortable with Unison, read some data

```
Tasks:
□ Install Unison, complete tutorial
□ Download sample dataset locally
□ Write function to parse CSV/JSON in REPL
□ Transform single record, test interactively
□ Write basic aggregation function
```

**Deliverable:** Functions that process one file locally

---

### Phase 2: Pipeline Composition (Week 2)
**Goal:** Chain transformations, write to Iceberg

```
Tasks:
□ Compose parsing → cleaning → aggregation
□ Handle IO abilities properly
□ Add error handling
□ Write to Iceberg table (explore PyIceberg or direct)
□ Query Iceberg: time travel queries in REPL
□ Write unit tests (in REPL!)
```

**Deliverable:** Local pipeline writing to Iceberg tables

---

### Phase 3: Distribution (Week 3-4)
**Goal:** Make it actually distributed

```
Tasks:
□ Split work across multiple nodes
□ Implement work distribution (map-reduce style)
□ Handle partial failures gracefully
□ Compare performance: local vs distributed
□ Measure energy usage (see tools below)
```

**Deliverable:** Distributed pipeline processing AWS data

---

### Phase 4: Carbon-Aware Optimization (Week 5)
**Goal:** Make the pipeline sustainable

```
Tasks:
□ Integrate real-time grid carbon intensity
□ Schedule heavy computation for low-carbon times
□ Optimize data movement (locality)
□ Measure carbon footprint of pipeline
□ Compare to equivalent Spark pipeline
```

**Deliverable:** Carbon-aware pipeline + metrics

---

## 🔬 Interesting Experiments

### Unison vs Spark Comparison
- Build equivalent pipeline in Spark
- Compare: code complexity, performance, resource usage, carbon footprint
- Write up findings for Green Software Foundation

### Carbon-Aware Scheduling
- Use grid carbon intensity to defer non-urgent processing
- Measure carbon savings vs. traditional "run immediately" approach
- Demonstrate Unison's advantage (pause/resume without serialization)

### Content-Addressing Benefits
- Show how code changes don't require full reprocessing
- Measure computation savings vs. rerun-everything approach
- Calculate carbon saved by incremental updates

---

## 📚 Resources & Tools

### Unison Resources
- [Unison Docs](https://www.unison-lang.org/docs/)
- [Unison Cloud](https://www.unison.cloud/) - For distributed deployment
- Unison Slack community (very helpful!)

### Carbon Measurement
- **Cloud Carbon Footprint** - Estimate AWS compute emissions
- **Electricity Maps API** - Real-time grid carbon intensity
- **Green Software Foundation SDKs** - Carbon-aware APIs
- **PowerJoular** - Measure local energy consumption

### Data Tools
- **AWS CLI / boto3** - Access S3 data
- **DuckDB** - Fast local analytics (compare to Unison)
- **Parquet** - Efficient columnar format

---

## 🎨 Output Ideas

### Code & Analysis
- GitHub repo with Unison pipeline
- Performance comparison notebook
- Carbon footprint analysis

### Community Sharing
- Blog post: "Building Carbon-Aware Pipelines with Unison"
- Talk proposal for Strange Loop (if it returns!) or Green Software Foundation events
- Contribution to Unison showcase projects

### Visualization
- Dashboard showing: data processed, carbon saved, grid intensity over time
- Before/after comparison: traditional pipeline vs. carbon-aware
- Interactive exploration of sustainability datasets

---

## 🚀 Getting Started Checklist

**This Week:**
- [ ] Install Unison (https://www.unison-lang.org/docs/quickstart/)
- [ ] Complete Unison tutorial
- [ ] Sign up for AWS (free tier works for SDI data)
- [ ] Browse SDI datasets, pick one that interests you
- [ ] Download sample data locally
- [ ] Write your first Unison function to read a file

**Week 2:**
- [ ] Parse a sustainability dataset in the REPL
- [ ] Write 3-5 transformation functions
- [ ] Compose them into a mini-pipeline
- [ ] Test with real data

---

## 💡 Why This Project Is Great for You

✅ **Aligns with work interests** - Airflow/Spark patterns, distributed data processing  
✅ **Explores Unison deeply** - Real use case, not toy example  
✅ **Mission-driven** - Sustainability matters to you  
✅ **Unique angle** - Carbon-aware computing + new language = novel insights  
✅ **Community value** - Green Software Foundation + Unison community would benefit  
✅ **Portfolio piece** - Demonstrates multiple skills + values  
✅ **Shareable** - Blog posts, talks, open source contribution  

---

## 🤔 Key Questions to Explore

1. **How does Unison's distributed model compare to Spark's for data pipelines?**
2. **Can content-addressing reduce carbon footprint via incremental processing?**
3. **What does "carbon-aware data processing" actually look like in practice?**
4. **Where does Unison shine vs. where does Spark still win?**

These questions make great blog post material!

---

## 🌱 Next Steps

1. **Start tiny** - Just get Unison running and read a CSV
2. **Stay curious** - Document what surprises you about Unison
3. **Share early** - Unison community loves seeing real projects
4. **Measure impact** - Track both learning and carbon metrics

Want to start with getting Unison installed and processing your first file? Or dive deeper into the dataset selection first?