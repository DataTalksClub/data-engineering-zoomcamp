import sys

import pandas as pd

print(sys.argv)

day = sys.argv[1] # first [0] argument is filename, [1] is first argument supplied

# some fancy stuff with pandas

print(f"job finished for the day = {day}")