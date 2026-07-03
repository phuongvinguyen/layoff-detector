
graph TD
    subgraph PDF_Extraction ["PDF to CSV Pipeline"]
        PDF_INPUT[/"data/raw/layoffs.pdf"\]
        READ_PDF[Read PDF Content]
        PARSE_PDF[Extract Table Data]
        SAVE_RAW[Save to folder data/raw]
        RAW_CSV[("data/raw/fyi_layoffs.csv")]
    end

    subgraph Data_Cleaning ["Data Cleaning & Deduplication"]
        CLEAN_START([Start Cleaning])
        REMOVE_OVERLAP[Remove Overlapping Records]
        MERGE_NAMES[Merge Similar Company Names]
        STRING_SIMILARITY[Merge Closely Related Strings]
        CLEANED_CSV[("cleaned_layoffs.csv")]
    end

    subgraph Finance_Pipeline ["get_finance_data Pipeline"]
        SEARCH_TICKERS[Search Tickers via yfinance.Search]
        DROP_MISSING[Drop Rows without Tickers]
        TICKERS_CSV[("LAYOFFS_WITH_TICKERS_CSV_PATH")]
        
        subgraph Data_Fetch ["Parallel Data Fetching"]
            FETCH_CASHFLOW[Fetch Quarterly Cashflow]
            FETCH_FINANCIALS[Fetch Quarterly Financials]
        end
        
        CASHFLOW_STORAGE[("CASHFLOW_DIR/*.csv")]
        FINANCIAL_STORAGE[("FINANCIAL_DATA_DIR/*.csv")]
    end

    PDF_INPUT --> READ_PDF
    READ_PDF --> PARSE_PDF
    PARSE_PDF --> SAVE_RAW
    SAVE_RAW --> RAW_CSV

    CLEAN_START --> REMOVE_OVERLAP
    REMOVE_OVERLAP --> MERGE_NAMES
    MERGE_NAMES --> STRING_SIMILARITY
    STRING_SIMILARITY --> CLEANED_CSV

    CLEANED_CSV --> SEARCH_TICKERS
    SEARCH_TICKERS --> DROP_MISSING
    DROP_MISSING --> TICKERS_CSV
    
    TICKERS_CSV --> FETCH_CASHFLOW
    TICKERS_CSV --> FETCH_FINANCIALS
    
    FETCH_CASHFLOW --> CASHFLOW_STORAGE
    FETCH_FINANCIALS --> FINANCIAL_STORAGE
    
    subgraph Main_Project ["Project: layoff-detector (root)"]
        START([start_point: generate_layoff])
    end

    subgraph PDF_Extraction ["PDF to CSV Pipeline"]
        PDF_INPUT[/"data/raw/layoffs.pdf"\]
        READ_PDF[Read PDF Content]
        PARSE_PDF[Extract Table Data]
        SAVE_RAW[Save to folder data/raw]
        RAW_CSV[("data/raw/fyi_layoffs.csv")]
    end

    subgraph Data_Ingestion ["Data Ingestion"]
        FILE_A[(File fyi_layoffs.csv.csv)]
        FILE_B[(File WARNDatabase2026.csv)]
        FILE_C[(File WARNDatabaseMasterExcluding2026_.csv)]
        
        CONV_LIST[Convert to List]
        SHOW_DATA[Display Data]
        PARSE_FORMAT[Parse Format]
    end

    subgraph Preprocessing ["Data Preprocessing"]
        DATE_TRANSFORM[Transform Date: DD.MM.Y to YY.MM.DD]
        NORMALIZE[Normalize Data]
        JOIN_FILES[Join into Single File]
    end

    subgraph Data_Cleaning ["Data Cleaning & Deduplication"]
        REMOVE_OVERLAP[Remove Overlapping Records]
        MERGE_NAMES[Merge Similar Company Names]
        STRING_SIMILARITY[Merge Closely Related Strings]
    end

    subgraph Output ["Final Output"]
        FINAL_GEN[Generate Final File]
        RESULT[(final_layoffs.csv)]
    end

    PDF_INPUT --> READ_PDF
    READ_PDF --> PARSE_PDF
    PARSE_PDF --> SAVE_RAW
    SAVE_RAW --> RAW_CSV

    RAW_CSV --> FILE_A
    START --> FILE_B
    START --> FILE_C

    FILE_A --> CONV_LIST
    FILE_B --> CONV_LIST
    FILE_C --> CONV_LIST

    CONV_LIST --> SHOW_DATA
    SHOW_DATA --> PARSE_FORMAT
    
    PARSE_FORMAT --> DATE_TRANSFORM
    DATE_TRANSFORM --> NORMALIZE
    NORMALIZE --> JOIN_FILES

    JOIN_FILES --> REMOVE_OVERLAP
    REMOVE_OVERLAP --> MERGE_NAMES
    MERGE_NAMES --> STRING_SIMILARITY
    
    STRING_SIMILARITY --> FINAL_GEN
    FINAL_GEN --> RESULT