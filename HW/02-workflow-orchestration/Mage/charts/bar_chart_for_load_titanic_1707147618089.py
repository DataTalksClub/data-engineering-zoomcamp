columns = df_1.columns
x = df_1.columns[:7]
y = [[v] for v in [len(df_1[col].unique()) for col in x]]
