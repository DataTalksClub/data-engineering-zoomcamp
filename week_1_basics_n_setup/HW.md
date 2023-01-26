DE Zoomcamp 2023 

Week 1 Homework

1.	Run the command to get information on Docker.  Which tag has the following text? – Write the image ID to the file  
	**Answer:** `--iidfile string`  
	**Code:** `docker build --help`

2.	Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash.  Now check the python modules that are installed (use pip list).  How 		many python packages/modules are installed?  
	**Answer:** 3  
	**Code:** `docker run -it –entrypoint=bash python:3.9`  
	`pip list -v`
3.	How many taxi trips were totally made on January 15th? (Using ny green taxi trip data)  
	**Answer:** 20530  
	**Code:**  
	```SELECT count(*)  
	FROM (
		SELECT date(lpep_pickup_datetime) 
			AS pickup, date(lpep_dropoff_datetime) dropoff
		FROM public.green_taxi_trips
		WHERE date(lpep_pickup_datetime) = '2019-01-15' 
			AND date(lpep_dropoff_datetime) = '2019-01-15'
	  ) one_day;
	  ```  
4.	Which was the day with the largest trip distance. Use the pick up time for your calculations.  
	**Answer:** 2019-01-05  
	**Code:**  
	```SELECT date(lpep_pickup_datetime), trip_distance
	     FROM public.green_taxi_trips gtt 
	     WHERE date(lpep_pickup_datetime) = date(lpep_pickup_datetime)
	     ORDER by 2 DESC;
	     ```  
5.	In 2019-01-01 how many trips had 2 and 3 passengers? (using pickup data only)  
	**Answer:** 2: 1282 ; 3: 254  
	**Code:**  
	```SELECT passenger_count, count(passenger_count) num
		FROM (
			SELECT passenger_count
			FROM public.green_taxi_trips gtt 
			WHERE date(lpep_pickup_datetime) = '2019-01-1' 
			 ) sub
		GROUP BY 1;
		```  
6.	For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip?  We want the name of the zone, not the id.  
	**Answer:** Long Island City/Queens Plaza  
	**Code:**   
	```WITH tb1 AS(
		SELECT "DOLocationID", "tip_amount"
		FROM public.green_taxi_trips gtt 
			JOIN public.zone_lookup zl 
				ON gtt."PULocationID" = zl."LocationID"
		WHERE zl."Zone" = 'Astoria'
		ORDER BY gtt."tip_amount" DESC 
		LIMIT 1)

		SELECT "Zone"
		FROM zone_lookup zl 
		WHERE "LocationID" = 146;
		```  
**Homework 1 PartB**  
    Question 1: Enter the Output Displayed After Running `terraform apply`  
       After running `terraform apply`, got the following results becuase I had setup the Dataset previously  
        **Answer:**  
	```google_bigquery_dataset.dataset: Creating...  
        google_storage_bucket.data-lake-bucket: Creating...  
        google_storage_bucket.data-lake-bucket: Creation complete after 2s \[id=dtc_data_lake_tribal-incline-374717]  
        
        Error: Error creating Dataset: googleapi: Error 409: Already Exists: Dataset tribal-incline-374717:trips_data_all, duplicate  
        
        with google_bigquery_dataset.dataset,  
        on main.tf line 45, in resource "google_bigquery_dataset" "dataset":  
        45: resource "google_bigquery_dataset" "dataset" {  
	```  

