flowchart TD
    subgraph DataRoot["OSINT and DATA Pipeline (layoff detector)"]
        Z[Direction] --> B[Collection] --> P[Processing] --> A[Analysis] --> E[Dissemination]
        P -->|feedback loop| B

        subgraph Order_Collection ["Data Collection Order"]
            I["pdf_to_csv.ipynb"] --> H["get_finance_data.ipynb"] 
        end

        subgraph Order_Processing ["Processing Order"]
            J["fix_ticker_conflicts_and_relabel.ipynb"] -.-> K["label_layoff.ipynb"]
            K --> L["generate_layoffs.ipynb"]
            L --> M["merged_bs_cs_fd.ipynb"]
        end

        subgraph Order_Analysis ["Analysis Order"]
            N["ml_test.ipynb"]
        end
        
        P -.-> J
        A -.-> N
        B -.-> I
    end