# How to setup dbt cloud with bigquery
[Official documentation](https://docs.getdbt.com/tutorial/setting-up)

## Create a BigQuery service account 
In order to connect we need the service account JSON file generated from bigquery:
1. Open the [BigQuery credential wizard](https://console.cloud.google.com/apis/credentials/wizard) to create a service account in your taxi project
 ![image](https://user-images.githubusercontent.com/4315804/152141360-4bc84b53-72f1-4e7c-b42b-7c97fe9aa6ca.png)

2. You can either grant the specific roles the account will need or simply use bq admin, as you'll be the sole user of both accounts and data. 
 ![image](https://user-images.githubusercontent.com/4315804/152141503-1ad64131-e867-47bf-905e-ee1d7115616c.png)
 ![image](https://user-images.githubusercontent.com/4315804/152141939-9ff88855-7c75-47c9-9088-2bfca0e3c0a3.png)
 ![image](https://user-images.githubusercontent.com/4315804/152142270-5aa8aec7-5cc7-4667-9ecc-721157de83d5.png)

3. Now that the service account has been created we need to add and download a JSON key, go to the keys section, select "create new key" 
 ![image](https://user-images.githubusercontent.com/4315804/152146423-769bdfee-3846-4296-8dee-d6843081c9b1.png)  
Select key type JSON and once you click on create it will get inmediately downloaded for you to use. 
 ![image](https://user-images.githubusercontent.com/4315804/152146506-5b3e2e0f-3380-414d-bc20-f35ea3f47726.png)

## Create a dbt cloud project 
1. Create a dbt cloud account from [their website](https://www.getdbt.com/pricing/) (free for solo developers)
2. Once you have logged in into dbt cloud you will be prompt to create a new project ![image](https://user-images.githubusercontent.com/4315804/152138242-f79bdb71-1fb4-4d8e-83c5-81f7ffc9ccad.png)
You are going to need: 
 - access to your data warehouse (bigquery - set up in weeks 2 and 3)
 - admin access to your repo, where you will have the dbt project. 
 _Note: For the sake of showing the creation of a project from scratch I've created a new empty repository just for this week project._ 
3. Name your project
4. Choose Bigquery as your data warehouse: ![image](https://user-images.githubusercontent.com/4315804/152138772-15950118-b69a-45b1-9c48-9c8a73581a05.png)
5. Upload the key you downloaded from BQ on the *create from file* option. This will fill out most fields related to the production credentials. Scroll down to the end of the page and set up your development credentials: 
 ![image](https://user-images.githubusercontent.com/4315804/152147146-db024d57-d119-4a5b-8e6f-5475664bdf56.png)  
6. Click on *Test* and after that you can continue with the setup 

 ## Add GitHub repository 
 _Note:_ This step could be skipped by using a managed repository if you don't have your own GitHub repo for the course.
1. Select git clone and paste the SSH key from your repo. 
 ![image](https://user-images.githubusercontent.com/4315804/152147493-2037bb54-cfed-4843-bef5-5c043fd36ec3.png)
 ![image](https://user-images.githubusercontent.com/4315804/152147547-44ab9d6d-5f3d-41a8-8f73-2d03a568e7aa.png)
2. You will get a deploy key, head to your GH repo and go to the settings tab. Under security you'll find the menu *deploy keys*
 ![image](https://user-images.githubusercontent.com/4315804/152147783-264f9da8-ec55-4d07-a9ec-4a8591006ea8.png)
3. Click on add key and paste the deploy key provided by dbt cloud. Make sure to tikce on "write access"
![image](https://user-images.githubusercontent.com/4315804/152147942-e76ff8b5-986d-4df1-88cc-ed3e98707d62.png)

## Review your project settings
At the end, if you go to your projects it should look some like this: 
![image](https://user-images.githubusercontent.com/4315804/152606066-f4d70546-7a5e-414a-9df9-8efd090216f8.png)


## [Optional] Link to your github account
You could simplify the process of adding and creating repositories by linking your GH account. [Official documentation](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-installing-the-github-application)




