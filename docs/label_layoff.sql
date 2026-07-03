flowchart TD
    subgraph Main_Project ["Script: layoff-detector -> label_layoff"]
        START([start_point: label_layoff])
    end

    subgraph Input_Files ["Input Files"]
        TICKER_INPUT[("layoffs_with_tickers_cleaned.csv or layoffs_with_tickers.csv")]
        FEATURES_INPUT[("merged_bs_cs_fd.csv")]
    end

    subgraph Load_Data ["Load Data"]
        LOAD_TICKERS[Load layoff data with tickers]
        LOAD_FEATURES[Load merged financial features]
    end

    subgraph Prepare_Events ["Prepare Layoff Events"]
        CONVERT_DATES[Convert date to datetime]
        DROP_NA[Drop rows without Ticker or date]
        EXTRACT_QUARTERS[Extract quarter from date]
        CREATE_EVENTS[Create layoff event set: Ticker + Quarter]
    end

    subgraph Prepare_Quarters ["Prepare Feature Quarters"]
        PARSE_QUARTERS[Parse feature quarters]
        GENERATE_SAME_NEXT[Generate same_quarter and next_quarter columns]
        CREATE_PAIRS[Create company + quarter pairs]
    end

    subgraph Generate_Labels ["Generate Labels"]
        LABEL_SAME[Label: layoff_same_quarter]
        LABEL_NEXT[Label: layoff_next_quarter]
        LABEL_COMBINED[Label: layoff_same_or_next_quarter]
        SET_TARGET[Set default target = same_or_next_quarter]
    end

    subgraph Output ["Output"]
        CONCAT[Concat features + labels]
        SAVE_CSV[Save to labeled_merged_data_cleaned.csv]
        OUTPUT_FILE[("labeled_merged_data_cleaned.csv")]
    end

    START --> TICKER_INPUT
    START --> FEATURES_INPUT
    
    TICKER_INPUT --> LOAD_TICKERS
    FEATURES_INPUT --> LOAD_FEATURES
    
    LOAD_TICKERS --> CONVERT_DATES
    CONVERT_DATES --> DROP_NA
    DROP_NA --> EXTRACT_QUARTERS
    EXTRACT_QUARTERS --> CREATE_EVENTS
    
    LOAD_FEATURES --> PARSE_QUARTERS
    PARSE_QUARTERS --> GENERATE_SAME_NEXT
    GENERATE_SAME_NEXT --> CREATE_PAIRS
    
    CREATE_EVENTS --> LABEL_SAME
    CREATE_EVENTS --> LABEL_NEXT
    CREATE_PAIRS --> LABEL_SAME
    CREATE_PAIRS --> LABEL_NEXT
    
    LABEL_SAME --> LABEL_COMBINED
    LABEL_NEXT --> LABEL_COMBINED
    LABEL_COMBINED --> SET_TARGET
    
    SET_TARGET --> CONCAT
    CONCAT --> SAVE_CSV
    SAVE_CSV --> OUTPUT_FILE