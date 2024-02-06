from mage_ai.data_cleaner.column_types.column_type_detector import infer_column_types

# df_1 = load_taxi

headers = ['value']
stats = ['Columns', 'Rows']
rows = [[len(df_1.columns)], [len(df_1.index)]]

print(rows, headers, stats)

# col_counts = {}
# for col, col_type in infer_column_types(df_1).items():
#     col_type_name = col_type.value
#     if not col_counts.get(col_type_name):
#         col_counts[col_type_name] = 0
#     col_counts[col_type_name] += 1

# for col_type, count in sorted(col_counts.items()):
#     stats.append(f'# of {col_type}')
#     rows.append([count])
