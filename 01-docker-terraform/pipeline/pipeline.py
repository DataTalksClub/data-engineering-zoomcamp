import sys
import pandas as pd

print('arguments', sys.argv)

month = int(sys.argv[1])

df = pd.DataFrame({
    'day': [1, 2, 3],
    'num_passengers': [4, 5, 6]
}).assign(**{'month': lambda x: month})

df.to_parquet('passengers.parquet', index=False)


print(df.head())

print(f'hello pipeline, month={month}')