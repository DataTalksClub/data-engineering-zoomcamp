import pandas as pd
import datetime

import sys

print(sys.argv)

dia =  datetime.date.today()

print('hello world, this docker is running')
print(f'o dia digitado pelo usuário foi {dia}')
