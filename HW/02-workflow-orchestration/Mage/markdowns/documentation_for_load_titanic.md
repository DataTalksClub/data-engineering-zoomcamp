# Python Script Documentation: Loading Data from API

## Purpose
The purpose of this python script is to load data from a specific data source, in this case, an API. The script uses the pandas library to read the data from the API and return it as a DataFrame.

## Libraries Used
The script uses the following libraries:
- io: Used for handling input and output operations.
- pandas: Used for data manipulation and analysis.
- requests: Used for making HTTP requests to the API.
- DataFrame: A class from the pandas library used for storing and manipulating tabular data.

## Function
The script contains a function called `load_data_from_api` which is used to load data from the API. The function is decorated with `@data_loader` which is used to register the function as a data loader. This allows the function to be used by other scripts for data preparation.

## Parameters
The function takes in `**kwargs` as a parameter. This allows for passing in any additional keyword arguments to the function.

## Data Source
The data source used in this script is a CSV file hosted on GitHub. The URL for the CSV file is `https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv?raw=True