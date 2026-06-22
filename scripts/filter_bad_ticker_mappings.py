from __future__ import annotations

import re
from collections import Counter
import pandas as pd

from layoff import config

INPUT_PATH = config.DATA_PROCESSED / "layoffs_with_tickers.csv"
OUTPUT_PATH = config.DATA_PROCESSED / "layoffs_with_tickers_cleaned.csv"
REPORT_PATH = config.DATA_PROCESSED / "ticker_conflict_report.csv"

FYI_SOURCE = "fyi_layoffs.csv"

GENERIC_TOKENS = {
    "A",
    "AN",
    "AND",
    "AT",
    "B",
    "C",
    "CO",
    "COMPANY",
    "COMPANIES",
    "CORP",
    "CORPORATION",
    "DBA",
    "D",
    "FKA",
    "FOR",
    "GROUP",
    "HOLDING",
    "HOLDINGS",
    "INC",
    "INCORPORATED",
    "L",
    "LC",
    "LLC",
    "LLP",
    "LP",
    "LTD",
    "OF",
    "P",
    "PC",
    "PLC",
    "SERVICES",
    "SERVICE",
    "THE",
    "TO",
}


def tokenize_company_name(name: object) -> list[str]:
    text = "" if pd.isna(name) else str(name).upper()
    text = re.sub(r"[^A-Z0-9]+", " ", text)
    return [
        token
        for token in text.split()
        if len(token) >= 2 and token not in GENERIC_TOKENS
    ]


def token_set(name: object) -> set[str]:
    return set(tokenize_company_name(name))


def ticker_stats(group: pd.DataFrame) -> dict[str, object]:
    names = group["Company_name"].dropna().astype(str).drop_duplicates()
    tokenized_names = [token_set(name) for name in names]
    token_counts = Counter(token for tokens in tokenized_names for token in tokens)
    top_token, top_token_count = ("", 0)

    if token_counts:
        top_token, top_token_count = token_counts.most_common(1)[0]

    unique_companies = len(names)
    top_token_coverage = (
        top_token_count / unique_companies if unique_companies else 0
    )
    has_fyi = group["source"].eq(FYI_SOURCE).any()

    # A ticker mapped to many unrelated names is usually a bad yfinance search hit.
    suspicious = unique_companies >= 10 and top_token_coverage < 0.60

    return {
        "unique_companies": unique_companies,
        "rows": len(group),
        "has_fyi": has_fyi,
        "top_token": top_token,
        "top_token_coverage": round(top_token_coverage, 3),
        "suspicious": suspicious,
    }


def build_report(df: pd.DataFrame) -> pd.DataFrame:
    rows = []

    for ticker, group in df.dropna(subset=["Ticker"]).groupby("Ticker"):
        stats = ticker_stats(group)
        sample_names = (
            group["Company_name"]
            .dropna()
            .astype(str)
            .drop_duplicates()
            .head(8)
            .tolist()
        )
        rows.append(
            {
                "Ticker": ticker,
                **stats,
                "sample_company_names": " | ".join(sample_names),
            }
        )

    report = pd.DataFrame(rows)
    return report.sort_values(
        ["suspicious", "unique_companies", "rows"],
        ascending=[False, False, False],
    )


def clean_mappings(df: pd.DataFrame, report: pd.DataFrame) -> pd.DataFrame:
    suspicious_tickers = set(report.loc[report["suspicious"], "Ticker"])
    cleaned = df.copy()

    cleaned["ticker_mapping_status"] = "kept"
    cleaned["ticker_mapping_reason"] = "ok"

    suspicious_mask = cleaned["Ticker"].isin(suspicious_tickers)
    fyi_mask = cleaned["source"].eq(FYI_SOURCE)

    # Keep FYI mappings because those are much closer to public tech-company layoffs.
    # Drop suspicious WARN mappings so random private companies do not create fake labels.
    drop_mask = suspicious_mask & ~fyi_mask
    cleaned.loc[drop_mask, "ticker_mapping_status"] = "dropped"
    cleaned.loc[
        drop_mask,
        "ticker_mapping_reason",
    ] = "ticker maps to many unrelated company names"

    cleaned = cleaned.loc[~drop_mask].copy()
    return cleaned


def main() -> None:
    df = pd.read_csv(INPUT_PATH)
    report = build_report(df)
    cleaned = clean_mappings(df, report)

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    cleaned.to_csv(OUTPUT_PATH, index=False)
    report.to_csv(REPORT_PATH, index=False)

    original_events = len(df)
    cleaned_events = len(cleaned)
    dropped_events = original_events - cleaned_events

    print(f"Wrote cleaned layoffs: {OUTPUT_PATH}")
    print(f"Wrote ticker report: {REPORT_PATH}")
    print(f"Original rows: {original_events}")
    print(f"Cleaned rows: {cleaned_events}")
    print(f"Dropped rows: {dropped_events}")
    print(f"Suspicious tickers: {int(report['suspicious'].sum())}")
    print()
    print("Worst suspicious tickers:")
    print(
        report.loc[
            report["suspicious"],
            [
                "Ticker",
                "unique_companies",
                "rows",
                "top_token",
                "top_token_coverage",
                "has_fyi",
            ],
        ]
        .head(20)
        .to_string(index=False)
    )


if __name__ == "__main__":
    main()
