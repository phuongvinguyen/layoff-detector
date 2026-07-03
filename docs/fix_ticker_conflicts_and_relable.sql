flowchart TD
    subgraph Root["fix_ticker_conflicts_and_relabel.ipynb"]
        
        subgraph Load_Data ["Load Data"]
            LOAD_TICKERS[Load layoffs_with_tickers.csv]
            INSPECT[Inspect data shape]
        end
        
        subgraph Conflict_Report ["Build Ticker Conflict Report"]
            TOKENIZE[Tokenize company names]
            STATS[Calculate stats per ticker]
            FLAG_SUSPICIOUS[Flag suspicious tickers]
            SAVE_REPORT[Save ticker_conflict_report.csv]
            REPORT[("ticker_conflict_report.csv")]
        end
        
        subgraph Clean_Data ["Clean Data"]
            DROP_SUSPICIOUS[Drop suspicious non-FYI mappings]
            ADD_METADATA[Add status & reason columns]
            SAVE_CLEANED[Save layoffs_with_tickers_cleaned.csv]
            CLEANED[("layoffs_with_tickers_cleaned.csv")]
        end
        
        subgraph Relabel ["Relabel with Financial Data"]
            LOAD_FEATURES[Load merged_bs_cs_fd.csv]
            QUARTER_MAPPING[Map layoffs to quarters]
            GENERATE_LABELS[Generate same/next quarter labels]
            COMBINE[Combine features + labels]
            SAVE_LABELED[Save labeled_merged_data_cleaned.csv]
            LABELED[("labeled_merged_data_cleaned.csv")]
        end
        
        LOAD_TICKERS --> INSPECT
        INSPECT --> TOKENIZE
        TOKENIZE --> STATS
        STATS --> FLAG_SUSPICIOUS
        FLAG_SUSPICIOUS --> SAVE_REPORT
        SAVE_REPORT --> REPORT
        
        INSPECT --> DROP_SUSPICIOUS
        DROP_SUSPICIOUS --> ADD_METADATA
        ADD_METADATA --> SAVE_CLEANED
        SAVE_CLEANED --> CLEANED
        
        SAVE_CLEANED --> QUARTER_MAPPING
        LOAD_FEATURES --> QUARTER_MAPPING
        QUARTER_MAPPING --> GENERATE_LABELS
        GENERATE_LABELS --> COMBINE
        COMBINE --> SAVE_LABELED
        SAVE_LABELED --> LABELED
    end

    subgraph Inputs ["Input Files"]
        direction LR
        TICKERS[("layoffs_with_tickers.csv")]
        FEATURES[("merged_bs_cs_fd.csv")]
    end

    TICKERS --> LOAD_TICKERS
    FEATURES --> LOAD_FEATURES