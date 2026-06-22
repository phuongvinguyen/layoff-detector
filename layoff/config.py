# config.py

# Central config for the layoff-detector:
#
# This file exists so you do not have to dig through each seperate file to change a setting.
# All constant variables (that do not change at runtime) should be stored here, and all files should import from here.
#
# How to define variables:
# Example: Filename = {LINK:"https://www.example.com",...}
# Attention: Capslock the variable since they are constants, and add a comment to explain what the variable is for.
# How to import variables:
# from config import 

# pdf_to_cvs_converter.ipynb:

from pathlib import Path
BASE_DIR = Path(__file__).parent.parent

# Directories
DATA_DIR       = BASE_DIR / "data"
DATA_RAW       = DATA_DIR / "raw"
DATA_CLEANED   = DATA_DIR / "cleaned"
DATA_PROCESSED = DATA_DIR / "processed"
DATA_BALANCE_SHEET = DATA_DIR / "balance_sheet"
DATA_CASHFLOWS = DATA_DIR / "cashflows"
DATA_FINANCIALS = DATA_DIR / "financials"

SRC_DIR = BASE_DIR / "src"

# Files 
PDF_TO_CSV = {
    "PDF_INPUT_PATH":  DATA_RAW / "Layoffs.pdf",
    "CSV_OUTPUT_PATH": DATA_RAW / "fyi_layoffs.csv",
}

GET_RAW = {
    "WARNDatabase2026" : DATA_RAW / "WARNDatabase2026.csv",
    "WARNDatabaseMasterExcluding2026" : DATA_RAW / "WARNDatabase2026.csv"
}

GET_FINANCIAL_DATA = {
    "INPUT_CSV_PATH":  DATA_CLEANED / "cleaned_layoffs.csv",
    "fyi_layoffs":  DATA_RAW / "fyi_layoffs.csv",
    "FILTERED_CSV_PATH": DATA_PROCESSED / "filtered_layoffs.csv",
    "LAYOFFS_WITH_TICKERS_CSV_PATH": DATA_PROCESSED / "layoffs_with_tickers.csv",
    "BALANCE_SHEET_DIR": DATA_DIR / "balance_sheet",
    "CASHFLOW_DIR": DATA_DIR / "cashflows",
    "FINANCIAL_DATA_DIR": DATA_DIR / "financials",
}

GET_FINANCIAL_DATA_COMBINED = {
    "INPUT_CSV_PATH": DATA_PROCESSED / "final_layoffs.csv",
    "LAYOFF_FILTERED_COMBINED_CSV_PATH": DATA_PROCESSED / "layoffSizeFiltered_combined.csv",
    "LAYOFFS_WITH_TICKERS_COMBINED_CSV_PATH": DATA_PROCESSED / "layoffs_with_tickers_combined.csv",
    "CLEANED_LAYOFF_COMBINED_CSV_PATH": DATA_CLEANED / "cleaned_layoffs_with_tickers_combined.csv"
}

MERGED_DATA = {
    "MERGED_OUTPUT_CSV_PATH": DATA_PROCESSED / "merged_bs_cs_fd.csv",
    "LABELED_OUTPUT_CSV_PATH": DATA_PROCESSED / "merged_bs_cs_fd.csv"
}

PIPELINE = {
    "INPUT_CSV_PATH": DATA_PROCESSED / "merged_bs_cs_fd.csv",
}

LABELED = {
    "LABELED_OUTPUT_CSV_PATH": DATA_PROCESSED / "labeled_merged_data.csv",
} 

# Configuration variables