flowchart LR
 A[Load dataset] --> B[Select colums for target, meta and features]
 B --> C[Create presence df] --> E[Drop all with 0 variance]
 B --> D[Fill nan with median value] --> F[Merged dataset]
 E --> F