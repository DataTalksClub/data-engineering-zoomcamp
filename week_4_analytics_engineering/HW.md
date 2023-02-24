DE Zoomcamp 2023  

Week 4 Homework  

1.	What is the count of records in the model fact_trips after running all models with the test run variable disabled and filtering for 2019 and 2020 data only (pickup datetime)
    **Answer:** 61,648,442  
    **Code:**   
    ```  
    SELECT count(*) FROM `tribal-incline-374717.dbt_nytaxi.fact_trips` WHERE EXTRACT(YEAR FROM pickup_datetime) in (2019, 2020)
    ```  
2.	What is the distribution between service type filtering by years 2019 and 2020 data as done in the videos . (Yellow/Green)  
    **Answer:** 89.9/10.1
    **Code:**    N/A  
     
3.	What is the count of records in the model stg_fhv_tripdata after running all models with the test run variable disabled  
    **Answer:**  43244696   
    **Code:**   
    ```  
      SELECT count(*) FROM `tribal-incline-374717.dbt_nytaxi.fhv_tripdata` where extract(year from pickup_datetime) = 2019
    ```  
4.	What is the count of records in the model fact_fhv_trips after running all dependencies with the test run variable disabled
	**Answer:**  22998722  
	**Code:**  
```
SELECT count(*) FROM `tribal-incline-374717.dbt_nytaxi.fact_fhv_trips` 
```

5.	What is the month with the biggest amount of rides after building a tile for the fact_fhv_trips table.
    **Answer:** January   
    **Code:** N/A   
