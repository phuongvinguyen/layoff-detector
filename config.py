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
PDF_TO_CSV = {
    "PDF_INPUT_PATH": "src/Layoffs.pdf",
    "CSV_OUTPUT_PATH": "src/layoffs.csv",
}