graph TD
    get_fin_data[get_fin_data_combined] --> LoadCleaned[Load Cleaned Layoffs Data]
    
    subgraph DataFiltering[Data Filtering Process]
        LoadCleaned --> FilterSize[Filter layoff_size >= 5]
        FilterSize --> SaveFiltered[Save to LAYOFF_FILTERED_COMBINED_CSV_PATH]
    end

    subgraph TickerAcquisition[Ticker Retrieval Process]
        SaveFiltered --> LoadFiltered[Read Filtered Data]
        LoadFiltered --> IterateCompanies[Iterate Company Names]
        IterateCompanies --> YFSearch[yfinance.Search Company]
        YFSearch --> ExtractSymbol[Extract First Quote Symbol]
        ExtractSymbol --> AppendTickers[Append Ticker to DataFrame]
        AppendTickers --> SaveWithTickers[Save to LAYOFFS_WITH_TICKERS_COMBINED_CSV_PATH]
    end

    subgraph FinalCleaning[Final Data Preparation]
        SaveWithTickers --> LoadWithTickers[Read Data with Tickers]
        LoadWithTickers --> DropEmpty[Drop Rows with Null Tickers]
        DropEmpty --> FinalExport[Save to CLEANED_LAYOFF_COMBINED_CSV_PATH]
    end