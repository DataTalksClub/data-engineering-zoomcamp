DE Zoomcamp 2023  

Week 5 Homework  

1.	Install Spark and PySpark and Execute spark.version.  What's the output?  

    **Answer:** 3.3.2  
    **Code:**   
    ```  
    spark.version
    ```  
2.	Read it with Spark using the same schema as we did in the lessons.
We will use this dataset for all the remaining questions.
Repartition it to 12 partitions and save it to parquet.
What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.  
    **Answer:** 24MB  
    **Code:**    ls -lh  
    
3.	How many taxi trips were there on June 15?  
    **Answer:**  452,470  
    **Code:**   
```  
spark.sql("""
SELECT count(*) FROM hvfhs_data
WHERE pickup_datetime like "2021-06-15%";
""").show()    
```
  
4.	Now calculate the duration for each trip.
How long was the longest trip in Hours?  
	**Answer:**  66.87 Hours  
	**Code:**  
```
spark.sql("""
SELECT MAX(TIMESTAMPDIFF(SECOND, `pickup_datetime`, `dropoff_datetime`)/3600.0) AS hours_diff
FROM hvfhs_data;
""").show() 
```

5.	Spark’s User Interface which shows application's dashboard runs on which local port?  
    **Answer:** 4040   
    **Code:** N/A   

6.	Using the zone lookup data and the fhvhv June 2021 data, what is the name of the most frequent pickup location zone?  
    **Answer:** Crown Heights North  
    **Code:**  
```
most_frequent = spark.sql("""
SELECT 
    Zone, 
    count(1) AS total
FROM
    combined
Group By 1
ORDER BY total DESC;
""").show()  
```   

