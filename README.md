# Ride Demand Forecasting — Data Preparation Engine

A Python/Jupyter Notebook project for preparing ride-hailing data for demand analysis and downstream forecasting. The notebook loads rider, trip, and city-zone data; checks data quality; cleans and transforms fields; engineers features; combines datasets; and produces exploratory analysis outputs and visualizations.

> **Scope note:** The notebook is a data-preparation and exploratory-data-analysis workflow. It does not currently train or evaluate a ride-demand forecasting model.

## Table of Contents

- [Project Overview](#project-overview)
- [Workflow](#workflow)
- [Input Data](#input-data)
- [Requirements](#requirements)
- [How to Run](#how-to-run)
- [Key Outputs](#key-outputs)
- [Important Implementation Notes](#important-implementation-notes)
- [Suggested Project Structure](#suggested-project-structure)

## Project Overview

The notebook works with three datasets:

- **Riders** — rider/customer attributes and ride-history fields.
- **Trips** — trip-level information such as date, distance, duration, fare, payment mode, and rider identifier.
- **City zones** — zone attributes including traffic information.

It uses pandas and NumPy for data handling, scikit-learn for imputation, encoding, and scaling, SciPy for outlier-related operations, and plotting/profiling libraries for exploratory analysis.

## Workflow

### 1. Load and understand the data

- Load `riders.xlsx` with pandas.
- Load `trips.json` with pandas.
- Read and execute SQL statements from `city_zones.sql` using SQLite to create the city-zone dataset.
- Inspect dataset information, sample rows, missing values, duplicates, and selected invalid values.

### 2. Clean the data

- Impute missing rider age values using the mean.
- Impute missing ride-count fields (`total_rides` and `cancelled_rides`) using the most frequent value.
- Parse rider signup dates with mixed date-format handling and coerce unparseable values to missing.
- Inspect trip records for negative fare values and invalid distance/fare combinations.
- Fill missing numeric values in the final dataset using column medians.

### 3. Detect and handle outliers

- Calculate Z-scores for trip fare and distance and inspect observations beyond an absolute Z-score of 3.
- Use the interquartile range (IQR) rule to identify unusual trip durations.
- Apply 5%/5% winsorization to fare values and compare descriptive statistics.
- Display before-and-after summaries where defined in the notebook.

### 4. Transform and encode features

- Extract hour, day of week, and month from the trip timestamp.
- Label-encode the rider `gender` field.
- Derive a traffic-level category from the city-zone `traffic_index` after filling missing traffic values with the median.
- Categorize rider trip frequency as `Low`, `Medium`, or `High`.
- Apply logarithmic transformations to fare and distance and a square-root transformation to trip duration.
- Create standardized and min-max-scaled versions of selected numeric trip features.

### 5. Construct features and combine datasets

- Add customer-level average ride distance and other engineered features defined in the notebook.
- Merge the enriched trip data with available rider and city-zone information where the relevant identifiers are present.
- Review the resulting final dataset's dimensions, missing values, and sample records.

### 6. Generate EDA outputs and visualizations

- Generate an HTML profiling report with `ydata-profiling`.
- Create visualizations for trip timing and surge-related information using Matplotlib and Seaborn.

## Input Data

Place the following files where the notebook can access them:

| File | Expected use |
|---|---|
| `riders.xlsx` | Rider/customer data |
| `trips.json` | Trip-level data |
| `city_zones.sql` | SQL statements used to build the city-zone table |

The notebook currently uses paths such as `/content/riders.xlsx` and `/content/trips.json`, which are typical of Google Colab. It reads `city_zones.sql` from the current working directory. Update these paths if running locally or in another environment.

The notebook expects columns referenced in its code, including fields such as `age`, `signup_date`, `total_rides`, `cancelled_rides`, `rider_id`, `trip_id`, `ride_date`, `distance_km`, `duration_min`, `fare_amount`, `surge_flag`, `payment_mode`, `zone_name`, and `traffic_index`. Exact schemas should be checked against the supplied data files before execution.

## Requirements

Python 3.10 or newer is a reasonable starting point; use a version compatible with the installed library releases.

Core packages used in the notebook:

```bash
pip install pandas numpy openpyxl scikit-learn scipy matplotlib seaborn ydata-profiling
```

SQLite support is provided by Python's standard-library `sqlite3` module.

If using Jupyter locally, install and launch it with:

```bash
pip install notebook
jupyter notebook
```

The notebook also contains a `pip install` cell for `ydata-profiling`; installing dependencies in the environment before running the notebook is generally easier to maintain.

## How to Run

1. Download or clone this project and place the three input files in the locations expected by the notebook.
2. Install the requirements listed above.
3. Open `RIDE_DEMAND_FORECASTING_DATA_PREP_ENGINE.ipynb` in Jupyter Notebook, JupyterLab, or Google Colab.
4. If using Colab, upload or mount the input files and confirm that the paths match the notebook.
5. Run the cells **from top to bottom**, because later cells depend on variables created earlier.
6. Review the printed summaries, plots, and profiling report.
7. Save any desired cleaned dataset or reports to a known output directory.

## Key Outputs

Depending on successful execution and the available input data, the notebook creates in-memory DataFrames and analysis outputs such as:

- `df_rider` — rider data after the notebook's loading and cleaning steps.
- `df_trip` — trip data with derived date/time fields and outlier-related columns.
- `df_city_zones` / `df_zones` — city-zone data and traffic-level features.
- `df_trip_cleaned` — the cleaned/enriched trip DataFrame used by later feature-engineering steps.
- `df_features` — trip data with engineered customer-level features.
- `df_final` — merged final analysis dataset.
- `df_scaled` — trip data with scaled numeric feature columns.
- An HTML EDA report generated by `ydata-profiling`.
- Visualizations for trip timing and surge status.

**Export reminder:** the notebook includes a final-dataset export section, but the visible code shown there only prints a success message and dataset shape. Add an explicit export statement (for example, `df_final.to_csv("ride_demand_prepared.csv", index=False)`) if you need a persistent CSV file.

## Important Implementation Notes

Please validate these points before treating the output as production-ready:

- **Input paths:** The notebook mixes `/content/...` paths with a relative path for the SQL file. Make them consistent for your environment.
- **Cleaning flow:** Some cells reload the original Excel file, which can overwrite previously imputed values. Keep a single documented cleaning pipeline if you need the transformations to persist consistently.
- **Invalid rides:** The notebook's explanatory text mentions zero-distance rides that were billed, but the corresponding displayed filter uses `distance_km < 0`. Confirm the intended business rule and implement the correct condition.
- **Outlier handling:** The notebook calculates outlier scores and winsorized fare values. Verify which records are removed or retained and which fare column is used downstream.
- **Log transforms:** Logarithms require positive values. Validate and handle zero or negative fare/distance values before applying `np.log`.
- **Feature scaling:** Fit scalers only on the appropriate training data when preparing a forecasting model, to avoid data leakage.
- **Categorical encoding:** Keep the mapping for label-encoded categories so encoded values remain interpretable and consistent.
- **Missing values:** Median imputation is applied to numeric columns in the final dataset; inspect remaining missing values in non-numeric columns as well.
- **Forecasting readiness:** For a true forecasting task, define a demand target (for example, trip counts aggregated by time interval and zone), establish a time-based train/validation/test split, and evaluate a forecasting model. Those steps are not implemented in this notebook.

## Suggested Project Structure

```text
ride-demand-forecasting/
├── RIDE_DEMAND_FORECASTING_DATA_PREP_ENGINE.ipynb
├── riders.xlsx
├── trips.json
├── city_zones.sql
├── README.md
└── outputs/
    ├── ride_demand_prepared.csv
    └── ride_demand_eda_report.html
```

AUTHOR

PATHAN SAHIL
