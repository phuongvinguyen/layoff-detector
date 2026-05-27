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

# Directories
DATA_DIR       = Path("../data")
DATA_RAW       = DATA_DIR / "raw"
DATA_CLEANED   = DATA_DIR / "cleaned"
DATA_PROCESSED = DATA_DIR / "processed"

# Files 
PDF_TO_CSV = {
    "PDF_INPUT_PATH":  DATA_RAW / "Layoffs.pdf",
    "CSV_OUTPUT_PATH": DATA_RAW / "fyi_layoffs.csv",
}

GET_FINANCIAL_DATA = {
    "INPUT_CSV_PATH":  DATA_RAW / "fyi_layoffs.csv",
    "OUTPUT_CSV_PATH": DATA_PROCESSED / "fyi_layoffs_with_financials.csv",
}