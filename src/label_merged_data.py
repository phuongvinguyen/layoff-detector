from __future__ import annotations

from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data"
FEATURES_PATH = DATA_DIR / "processed" / "merged_bs_cs_fd.csv"
RAW_LAYOFFS_PATH = DATA_DIR / "processed" / "layoffs_with_tickers.csv"
CLEANED_LAYOFFS_PATH = DATA_DIR / "processed" / "layoffs_with_tickers_cleaned.csv"
OUTPUT_PATH = DATA_DIR / "processed" / "labeled_merged_data.csv"
FALLBACK_OUTPUT_PATH = DATA_DIR / "processed" / "labeled_merged_data_cleaned.csv"


def choose_layoff_input() -> Path:
    if CLEANED_LAYOFFS_PATH.exists():
        return CLEANED_LAYOFFS_PATH
    return RAW_LAYOFFS_PATH


def main() -> None:
    layoff_input = choose_layoff_input()
    features_df = pd.read_csv(FEATURES_PATH)
    layoffs = pd.read_csv(layoff_input)

    layoffs["date"] = pd.to_datetime(layoffs["date"], errors="coerce")
    layoffs = layoffs.dropna(subset=["Ticker", "date"])
    layoffs["quarter"] = layoffs["date"].dt.to_period("Q").astype(str)

    layoff_events = set(
        zip(
            layoffs["Ticker"].astype(str),
            layoffs["quarter"].astype(str),
        )
    )

    feature_quarters = pd.PeriodIndex(features_df["quarter"], freq="Q")
    label_df = pd.DataFrame(
        {
            "same_quarter": feature_quarters.astype(str),
            "next_quarter": (feature_quarters + 1).astype(str),
        }
    )

    same_quarter_pairs = list(
        zip(features_df["company"].astype(str), label_df["same_quarter"])
    )
    next_quarter_pairs = list(
        zip(features_df["company"].astype(str), label_df["next_quarter"])
    )

    label_df["layoff_same_quarter"] = (
        pd.Series(same_quarter_pairs).isin(layoff_events).astype(int).values
    )
    label_df["layoff_next_quarter"] = (
        pd.Series(next_quarter_pairs).isin(layoff_events).astype(int).values
    )
    label_df["layoff_same_or_next_quarter"] = (
        (label_df["layoff_same_quarter"] == 1)
        | (label_df["layoff_next_quarter"] == 1)
    ).astype(int)

    # Default target for modeling. Use layoff_next_quarter if you want stricter prediction.
    label_df["layoff"] = label_df["layoff_same_or_next_quarter"]

    dataset = pd.concat([features_df.reset_index(drop=True), label_df], axis=1)

    output_path = OUTPUT_PATH
    try:
        dataset.to_csv(output_path, index=False)
    except PermissionError:
        output_path = FALLBACK_OUTPUT_PATH
        dataset.to_csv(output_path, index=False)

    print(f"Layoff input: {layoff_input}")
    print(f"Wrote: {output_path}")
    print(f"Rows: {len(dataset)}")
    print(f"Companies: {dataset['company'].nunique()}")
    print("Label counts:")
    print(
        dataset[
            [
                "layoff_same_quarter",
                "layoff_next_quarter",
                "layoff_same_or_next_quarter",
                "layoff",
            ]
        ].sum()
    )
    print(
        "Positive companies:",
        dataset.loc[dataset["layoff"].eq(1), "company"].nunique(),
    )


if __name__ == "__main__":
    main()
