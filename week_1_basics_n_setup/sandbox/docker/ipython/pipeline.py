import sys

import pandas as pd


def extract() -> str:
	placeholder_extract = "more interesting stuff can happen"
	return placeholder_extract

def transform(extraction: str) -> str:
	transformed_extraction = extraction.upper()
	return transformed_extraction

def load(clean_data) -> None:
	print(clean_data)

def main():
	extraction = extract()
	clean_data = transform(extraction)
	load(clean_data)


if __name__ == "__main__":
	print(sys.argv)
	print(f"arg_0: {sys.argv[0]}")
	day = sys.argv[1]
	print(f"arg_1: {day}")
	main()