# Marketing Attribution Case Studyъ

This repository demonstrates a marketing attribution pipeline based on user-level touchpoints and multi-touch attribution models.

The project includes:
- Data preparation in BigQuery (SQL)
- Baseline attribution models (Last Click, First Click, Linear)
- Markov chain attribution using Python

---

## 1. Objective

The goal of this project is to estimate channel contribution to conversions based on user journeys.

---

## 2. Data Model

### Layer 1: Touchpoints

Table: `final_dataset.touchpoints`

Each row represents a marketing interaction:

| user_id | event_dt | channel | conversions |
|----------|----------|----------|-------------|

This layer is built from unified raw marketing and web data.

---

### Layer 2: Conversion Paths

Table: `final_dataset.channel_paths_grouped`

Each row represents a unique user journey:

| conversion_path | conversions | zeropath |
|-----------------|------------|----------|

Example:

Google > YouTube > Direct

Where:
- `conversions` = number of converting users with this path
- `zeropath` = number of non-converting users with this path

---

## 3. Baseline Attribution Models (SQL)

Implemented in `sql/03_baseline_attribution.sql`:

- Last Click
- First Click
- Linear

---

## 4. Markov Attribution (Python)

Implemented in `python/01_markov_attribution.py`.

The Markov model:

1. Treats user journeys as state transitions
2. Estimates transition probabilities between channels
3. Redistributes conversions based on marginal channel impact


---

## 5. Architecture Overview

BigQuery (SQL):
Raw Data → Touchpoints → Conversion Paths → Baseline Attribution

Python:
Conversion Paths → Markov Model → Channel Contribution

---

## 7. Notes

- All dataset names and identifiers are anonymized.
- Example CSV is used for demonstration.
