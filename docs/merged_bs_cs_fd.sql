flowchart TD
    subgraph Main_Project ["Script: layoff-detector -> merged_bs_cs_fd"]
        START([start_point: merged_bs_cs_fd])
    end

    subgraph Input_Files ["Input Files"]
        BALANCE_SHEET[("DATA_BALANCE_SHEET/*_balancesheet.csv")]
        CASHFLOW[("DATA_CASHFLOWS/*_cashflow.csv")]
        FINANCIALS[("DATA_FINANCIALS/*_financials.csv")]
    end

    subgraph Function ["Helper Function"]
        FUNC[statement_to_dict_df: Convert CSV to dict DataFrame]
    end

    subgraph Ticker_Extraction ["Extract Tickers"]
        EXTRACT_TICKERS[Extract unique tickers from balance sheet files]
    end

    subgraph Loop_Companies ["Loop Through Companies"]
        LOOP_START[For each ticker]
        
        subgraph Load_Statements ["Load Statements"]
            LOAD_BS[Load balance sheet if exists]
            LOAD_CF[Load cashflow if exists]
            LOAD_FIN[Load financials if exists]
        end
        
        subgraph Merge_Company ["Merge Company Data"]
            MERGE_ALL[Merge all statements on company + date]
            APPEND_MASTER[Append to master_rows]
        end
    end

    subgraph Combine ["Combine & Process"]
        CONCAT[Concatenate all company data]
        EXTRACT_QUARTER[Extract quarter from date]
        
        subgraph Normalize ["Normalize Features"]
            NORM_BS[Normalize balance sheet -> bs_*]
            NORM_CF[Normalize cashflow -> cf_*]
            NORM_FIN[Normalize financials -> fin_*]
        end
        
        FINAL_DF[Concat company + date + quarter + all features]
    end

    subgraph Output ["Output"]
        SAVE[Save to merged_bs_cs_fd.csv]
        OUTPUT_FILE[("merged_bs_cs_fd.csv")]
    end

    START --> FUNC
    START --> EXTRACT_TICKERS
    
    BALANCE_SHEET --> EXTRACT_TICKERS
    CASHFLOW --> LOOP_START
    FINANCIALS --> LOOP_START
    
    EXTRACT_TICKERS --> LOOP_START
    
    LOOP_START --> LOAD_BS
    LOOP_START --> LOAD_CF
    LOOP_START --> LOAD_FIN
    
    LOAD_BS --> MERGE_ALL
    LOAD_CF --> MERGE_ALL
    LOAD_FIN --> MERGE_ALL
    
    MERGE_ALL --> APPEND_MASTER
    APPEND_MASTER --> CONCAT
    
    CONCAT --> EXTRACT_QUARTER
    EXTRACT_QUARTER --> NORM_BS
    EXTRACT_QUARTER --> NORM_CF
    EXTRACT_QUARTER --> NORM_FIN
    
    NORM_BS --> FINAL_DF
    NORM_CF --> FINAL_DF
    NORM_FIN --> FINAL_DF
    
    FINAL_DF --> SAVE
    SAVE --> OUTPUT_FILE