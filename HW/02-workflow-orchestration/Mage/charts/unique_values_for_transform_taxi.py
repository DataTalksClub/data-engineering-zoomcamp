columns = df_1.columns
number_of_unique_values = [df_1[col].nunique() for col in columns]
print(number_of_unique_values)