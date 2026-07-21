graph LR

File A [""]
File B
File C

FILE A: layoffs.csv format         '7.5.2026'      → 2026-05-07 [DD.MM.YYYY]
FILE B: WARN 2026                  '05/01/2026'    → 2026-05-01 [DD/MM/YYYY]
FILE C: WARN Master                '12/31/2025'    → 2025-12-31 [MM/DD/YYYY]

TARGET FORMAT: YYYY-MM-DD
GET A SINGLE FILE.  

THEM also do the normalization

|Source column| Target column | Notes|
|-------------|---------------|------|
|Company / Company / Company | Company_name | strip lead/tail whitespace|
| # Laid Off / Number of Workers / Number of Workers | layoff_size | coerce to numeric; non-numeric → NaN |
| Date / WARN Received Date / WARN Received Date | date | parsed via parse_date() above |

target:
Company_name	layoff_size	date	source
0	Vacuum Technique LLC	78.0	2025-12-31	WARNDatabaseMasterExcluding2026.csv
1	Kroehler Furniture Co.	208.0	2025-12-30	WARNDatabaseMasterExcluding2026.csv
2	Mare Island Dry Dock, LLC	84.0	2025-12-30	WARNDatabaseMasterExcluding2026.csv


merge everything

uppercase companie names,
remove intersection between warn and fyi
remove companies without tickers
filter out bad tickers as different companies share the same tickers
merge all the financial data and transform data into features + dates + quarters + ... 
label the layoff (1/0) 

tickers - 
features - 
label - 

Obs.: There are more steps, but I prefer to keep it simple for now.



---- 
Diagrams:
graph LR

    A["fyi_layoffs.csv - DD.MM.YYYY"]
    B["WARNDatabase2026.csv - DD/MM/YYYY"]
    C["WARNDatabaseMasterExcluding2026.csv - MM/DD/YYYY"]
    NORM["Parse dates, normalize schema and merge into one dataset"]

    A --> NORM
    B --> NORM
    C --> NORM

    D["NASDAQ.csv"]
    FT["Fetch tickers"]
    D --> FT

    UP["Uppercase company names"]
    INT["Remove overlap data"]

    NORM --> UP --> INT

    subgraph VERT[" "]
        direction TB
        TICK["Remove companies without tickers"]
        BAD["Filter bad or shared tickers"]
        FETCH["Fetch data from yfinance"]
        FIN["Merge financial data - features and quarters"]
        LABEL["Label layoff 1 or 0"]
        O1["tickers"]
        O2["features"]
        O3["label (0/1)"]

        TICK --> BAD --> FETCH --> FIN --> LABEL
        LABEL -.-> O1
        LABEL -.-> O2
        LABEL -.-> O3
        LABEL -->|feedback loop| TICK
    end

    INT --> FT
    FT --> TICK