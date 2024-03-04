# Week 5: Batch Processing

## 5.1 Introduction

* :movie_camera: 5.1.1 Introduction to Batch Processing

[![](https://markdown-videos-api.jorgenkh.no/youtube/dcHe5Fl3MF8)](https://youtu.be/dcHe5Fl3MF8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=51)

* :movie_camera: 5.1.2 Introduction to Spark

[![](https://markdown-videos-api.jorgenkh.no/youtube/FhaqbEOuQ8U)](https://youtu.be/FhaqbEOuQ8U&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=52)


## 5.2 Installation

Follow [these intructions](setup/) to install Spark:

* [Windows](setup/windows.md)
* [Linux](setup/linux.md)
* [MacOS](setup/macos.md)

And follow [this](setup/pyspark.md) to run PySpark in Jupyter

* :movie_camera: 5.2.1 (Optional) Installing Spark (Linux)

[![](https://markdown-videos-api.jorgenkh.no/youtube/hqUbB9c8sKg)](https://youtu.be/hqUbB9c8sKg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=53)

Alternatively, if the setups above don't work, you can run Spark in Google Colab.
> [!NOTE]  
> It's advisable to invest some time in setting things up locally rather than immediately jumping into this solution

* [Google Colab Instructions](https://medium.com/gitconnected/launch-spark-on-google-colab-and-connect-to-sparkui-342cad19b304)
* [Google Colab Starter Notebook](https://github.com/aaalexlit/medium_articles/blob/main/Spark_in_Colab.ipynb)


## 5.3 Spark SQL and DataFrames

* :movie_camera: 5.3.1 First Look at Spark/PySpark

[![](https://markdown-videos-api.jorgenkh.no/youtube/r_Sf6fCB40c)](https://youtu.be/r_Sf6fCB40c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=54)

* :movie_camera: 5.3.2 Spark Dataframes

[![](https://markdown-videos-api.jorgenkh.no/youtube/ti3aC1m3rE8)](https://youtu.be/ti3aC1m3rE8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=55)

* :movie_camera: 5.3.3 (Optional) Preparing Yellow and Green Taxi Data

[![](https://markdown-videos-api.jorgenkh.no/youtube/CI3P4tAtru4)](https://youtu.be/CI3P4tAtru4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=56)

Script to prepare the Dataset [download_data.sh](code/download_data.sh)

> [!NOTE]  
> The other way to infer the schema (apart from pandas) for the csv files, is to set the `inferSchema` option to `true` while reading the files in Spark.

* :movie_camera: 5.3.4 SQL with Spark

[![](https://markdown-videos-api.jorgenkh.no/youtube/uAlp2VuZZPY)](https://youtu.be/uAlp2VuZZPY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=57)


## 5.4 Spark Internals

* :movie_camera: 5.4.1 Anatomy of a Spark Cluster

[![](https://markdown-videos-api.jorgenkh.no/youtube/68CipcZt7ZA)](https://youtu.be/68CipcZt7ZA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=58)

* :movie_camera: 5.4.2 GroupBy in Spark

[![](https://markdown-videos-api.jorgenkh.no/youtube/9qrDsY_2COo)](https://youtu.be/9qrDsY_2COo&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=59)

* :movie_camera: 5.4.3 Joins in Spark

[![](https://markdown-videos-api.jorgenkh.no/youtube/lu7TrqAWuH4)](https://youtu.be/lu7TrqAWuH4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=60)

## 5.5 (Optional) Resilient Distributed Datasets

* :movie_camera: 5.5.1 Operations on Spark RDDs

[![](https://markdown-videos-api.jorgenkh.no/youtube/Bdu-xIrF3OM)](https://youtu.be/Bdu-xIrF3OM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=61)

* :movie_camera: 5.5.2 Spark RDD mapPartition

[![](https://markdown-videos-api.jorgenkh.no/youtube/k3uB2K99roI)](https://youtu.be/k3uB2K99roI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=62)


## 5.6 Running Spark in the Cloud

* :movie_camera: 5.6.1 Connecting to Google Cloud Storage

[![](https://markdown-videos-api.jorgenkh.no/youtube/Yyz293hBVcQ)](https://youtu.be/Yyz293hBVcQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=63)

* :movie_camera: 5.6.2 Creating a Local Spark Cluster

[![](https://markdown-videos-api.jorgenkh.no/youtube/HXBwSlXo5IA)](https://youtu.be/HXBwSlXo5IA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=64)

* :movie_camera: 5.6.3 Setting up a Dataproc Cluster

[![](https://markdown-videos-api.jorgenkh.no/youtube/osAiAYahvh8)](https://youtu.be/osAiAYahvh8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=65)

* :movie_camera: 5.6.4 Connecting Spark to Big Query

[![](https://markdown-videos-api.jorgenkh.no/youtube/HIm2BOj8C0Q)](https://youtu.be/HIm2BOj8C0Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=66)


# Homework

* [2024 Homework](../cohorts/2024/05-batch/homework.md)


# Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/5_batch_processing.md)
* [Sandy's DE Learning Blog](https://learningdataengineering540969211.wordpress.com/2022/02/24/week-5-de-zoomcamp-5-2-1-installing-spark-on-linux/)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week5.md)
* [Alternative : Using docker-compose to launch spark by rafik](https://gist.github.com/rafik-rahoui/f98df941c4ccced9c46e9ccbdef63a03) 
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-5-batch-spark)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week5)
* [Notes by Oscar Garcia](https://github.com/ozkary/Data-Engineering-Bootcamp/tree/main/Step5-Batch-Processing)
* [Notes by HongWei](https://github.com/hwchua0209/data-engineering-zoomcamp-submission/blob/main/05-batch-processing/README.md)
* [2024 videos transcript](https://drive.google.com/drive/folders/1XMmP4H5AMm1qCfMFxc_hqaPGw31KIVcb?usp=drive_link) by Maria Fisher 
* Add your notes here (above this line)
