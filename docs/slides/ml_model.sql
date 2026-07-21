flowchart LR
 A[Merged dataset] --> B[StratfieldKFold provide train and test set]
B --> C[Model overview]
C --> Random_Forest --> Result
C --> XGBoost --> Result
C --> Gradient_Boosting --> Result
C --> Logistic_Regression --> Result
C --> SVM --> Result
C --> KNN --> Result