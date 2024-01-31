# Cloud-Based Environment Setup

**Objective:**
Setting up of a comprehensive environment on a Google Cloud Platform (GCP) virtual machine (VM)

Follow the steps outlined in the [video tutorial](https://www.youtube.com/watch?v=ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

**Project Steps:**

1. **Create Google Cloud Platform Account:**
   - [x] Create a new email address to use for this project and get 300euros worth of credit from Google.
   - [x] Create an account for Google Cloud Platform. 

2. **Log in to GCP:**
   - [x] Access GCP through your web browser and log in to your account.

3. **Project Initialization:**
   - [x] Create a new GCP project to organize your resources efficiently.
   - [x] For this specific project I named it "data-engineering"

4. **Budget Management:**
   - [x] Set up a Google Cloud budget to monitor and control your project expenses.

5. **SSH Key Generation:**
   - [x] Open your local machine terminal/powershell
   - [x] Generate SSH keys for secure communication between your local machine and the GCP VM.
   - [x] This [document](https://cloud.google.com/compute/docs/connect/create-ssh-keys#rest) describes how to create an SSH key pair for Compute Engine virtual machine (VM) instances. Command: `ssh-keygen -t rsa -f ~/.ssh/KEY_FILENAME -C USERNAME -b 2048`

6. **Virtual Machine Creation:**
   - [x] Create a virtual machine on GCP to host your development environment.
   - [x] VM details: Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1048-gcp x86_64)

7. **SSH Connection Setup:**
   - [x] Save Your Public SSH Key to Clipboard.
   - [x] Add SSH Key to GCP Compute Engine: Navigate to GCP: Menu -> Compute Engine -> Metadata -> SSH Keys.
   - [x] Click "Add SSH Key" and paste your public SSH key.
   - [x] Connect to GCP VM using SSH:
   - Go to your terminal/powershell and use this command: `ssh -i ~/.ssh/<private-ssh-key-filename> <GCP-account-name>@<VM-External-IP>`. Ensure to replace <private-ssh-key-filename>, <GCP-account-name>, and <VM-External-IP> with your specific values
   - [x] Confirm the connection when prompted:

```
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

   - [x] Successful connection results in a welcome message displaying system information.
```
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1048-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jan 22 08:15:34 UTC 2024

  System load:  0.22              Processes:             106
  Usage of /:   9.8% of 19.20GB   Users logged in:       0
  Memory usage: 3%                IPv4 address for ens4: 0.0.0.0
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.
```
- [x] Use `htop` for System Monitoring: a command-line tool used to monitor and manage the processes running on a computer. It provides a visual representation of the system's resources, such as CPU usage, memory usage, and more. htop allows you to see which processes are using the most resources and gives you the ability to interactively manage them, such as killing a process if needed.
- [x] Initial Check with ls: Upon the first ls command, confirm that the VM file system is empty. Validate the absence of any pre-existing files or directories.
- [x] Execute the command `gcloud --version` to verify the Google Cloud SDK version. 

```
Google Cloud SDK 459.0.0
alpha 2024.01.06
beta 2024.01.06
bq 2.0.101
bundled-python3-unix 3.11.6
core 2024.01.06
gcloud-crc32c 1.0.0
gsutil 5.27
minikube 1.32.0
skaffold 2.9.0
```

8. **Tool Installation on VM:**
   - [x] Install Anaconda:
   
Using these commands:
- Linux: `wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-MacOSX-arm64.sh`
- `bash Anaconda3-2023.09-0-Linux-x86_64.sh`
```
Welcome to Anaconda3 2023.09-0

In order to continue the installation process, please review the license
agreement.
Please, press ENTER to continue
>>> 
==================================================
End User License Agreement - Anaconda Distribution
==================================================

Copyright 2015-2023, Anaconda, Inc.

All rights reserved under the 3-clause BSD License:

This End User License Agreement (the "Agreement") is a legal agreement between you and Anaconda, Inc. ("Anaconda") and governs your 
use of Anaconda Distribution (which was formerly known as Anaconda Individual Edition).

Subject to the terms of this Agreement, Anaconda hereby grants you a non-exclusive, non-transferable license to:

  * Install and use the Anaconda Distribution (which was formerly known as Anaconda Individual Edition),
  * Modify and create derivative works of sample source code delivered in Anaconda Distribution from Anaconda's repository, and;
  * Redistribute code files in source (if provided to you by Anaconda as source) and binary forms, with or without modification subj
ect to the requirements set forth below, and;

Anaconda may, at its option, make available patches, workarounds or other updates to Anaconda Distribution. Unless the updates are p
rovided with their separate governing terms, they are deemed part of Anaconda Distribution licensed to you as provided in this Agree
ment.  This Agreement does not entitle you to any support for Anaconda Distribution.

Anaconda reserves all rights not expressly granted to you in this Agreement.

Continued...

installation finished.
Do you wish to update your shell profile to automatically initialize conda?
This will activate conda on startup and change the command prompt when activated.
If you'd prefer that conda's base environment not be activated on startup,
   run the following command when conda is activated:

conda config --set auto_activate_base false

You can undo this by running `conda init --reverse $SHELL`? [yes|no]
[no] >>> yes

==> For changes to take effect, close and re-open your current shell. <==

Thank you for installing Anaconda3!

```  


   - [x] Use `ls` command to confirm, it should appear
```
Anaconda3-2023.09-0-Linux-x86_64.sh  Anaconda3-2023.09-0-MacOSX-arm64.sh  anaconda3  snap
```

   - [x] Install Docker
`sudo apt-get update`
`sudo apt-get install docker.io`
`docker`
`sudo groupadd docker`
`sudo gpasswd -a $USER docker`
`sudo service docker restart`
`docker run hello-world`
Try running: `docker run -it ubuntu bash` if it works

   - [x] Install Docker Compose
`mkdir bin`
`cd bin/`
`wget https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-x86_64`
`ls`
`chmod +x docker-compose-linux-x86_64`
`ls`
`./docker-compose-linux-x86_64`
`./docker-compose-linux-x86_64 version`
`which docker-compose-linux-x86_64 `
`docker ps`

9. **Clone the repository using HTTPS:**
    - [x] `git clone <HTTPS link>`


10. **SSH Configuration:**
   - [x] Create an SSH configuration file for streamlined access to the remote machine.

`cd .ssh`
`ls`
`sudo snap install code`
`code config` or open config file to any Code Editor

And paste this:
```
Host <VM Name>
  HostName <VM External IP>
  User <GCP AccountName>
  IdentityFile ~/.ssh/<Private key filename>
```

`ssh <VM Name>`
```
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1048-gcp x86_64)
```

`which python`

11. **IDE Integration:**
    - [x] Open VSCode -> Go to Extensions
    - [x] Install remote-ssh
    - [x] At the lower left corner of your VSCode there is a button similar to this ><. Click Open a Remote Window
    - [x] Click "connect to host" -> choose your <VMName>
    - [x] Go to VSCode terminal and do `ls`, it will confirm that you are on your VM.      
    - [x] And have access the remote machine using Visual Studio Code and SSH remote connection.

12. **Docker Compose Installation:**
    - [x] Install docker-compose for managing multi-container Docker applications.

13. **Database Interaction:**
    - [x] Install pgcli for PostgreSQL interaction.

`docker ps`
Go to the file where "docker-compose.yaml" is, then run:
`docker-compose-linux-x86_64 up -d`
`docker ps`
It will look like this
```
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS         PORTS                                            NAMES
38ebd88a8b0d   postgres:13      "docker-entrypoint.s…"   11 seconds ago   Up 6 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp        2_docker_sql-pgdatabase-1
37e21e00ba1b   dpage/pgadmin4   "/entrypoint.sh"         11 seconds ago   Up 7 seconds   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp   2_docker_sql-pgadmin-1
```

**Run PostgreSQL using pip**

`pip install pgcli`
`pgcli -h localhost -U root -d ny_taxi`
```
Server: PostgreSQL 13.13 (Debian 13.13-1.pgdg120+1)
Version: 4.0.1
Home: http://pgcli.com

root@localhost:ny_taxi> \dt
+--------+------+------+-------+
| Schema | Name | Type | Owner |
|--------+------+------+-------|
+--------+------+------+-------+
SELECT 0
Time: 0.010s
```
`pip uninstall pgcli`

**Run PostgreSQL using anaconda**

`conda install -c conda-forge pgcli`
`pip install --upgrade pgcli`
`pgcli -h localhost -U root -d ny_taxi`

```
Server: PostgreSQL 13.13 (Debian 13.13-1.pgdg120+1)
Version: 4.0.1
Home: http://pgcli.com
root@localhost:ny_taxi> \dt
+--------+------+------+-------+
| Schema | Name | Type | Owner |
|--------+------+------+-------|
+--------+------+------+-------+
SELECT 0
Time: 0.012s

```


14. **Port Forwarding Configuration:**
    - [x] Go to VSCode -> Click Status Bar (bottom left) -> Click PORTS
    - [x] Click "Forward a Port"
    - [x] Type 5432 for pgadmin and go to the forwarded address
    - [x] Type 8080 for jupyter notebook and go to the forwarded address
    - [x] Go back to terminal and run: `jupyter notebook`
    - [x] On your repo go to where your "upload-data.ipynb" Python script is and run the code.
    - [x] Configure port-forwarding in Visual Studio Code to connect to pgAdmin and Jupyter from your local machine.


**Uploading Data to PostgresSQL**
Run `wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz` where your upload-data.ipynb is

`pgcli -h localhost -U root -d ny_taxi`

```
Server: PostgreSQL 13.13 (Debian 13.13-1.pgdg120+1)
Version: 4.0.1
Home: http://pgcli.com
root@localhost:ny_taxi> \dt
+--------+------------------+-------+-------+
| Schema | Name             | Type  | Owner |
|--------+------------------+-------+-------|
| public | yellow_taxi_data | table | root  |
+--------+------------------+-------+-------+
SELECT 1
Time: 0.014s

root@localhost:ny_taxi> select count(1) from yellow_taxi_data;
+-------+
| count |
|-------|
| 69765 |
+-------+
SELECT 1
Time: 0.027s
root@localhost:ny_taxi> exit
Goodbye!

```


15. **Infrastructure as Code (IaC):**

    - [x] Install Terraform for automated infrastructure provisioning and management.

`cd bin`
`wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip`
`sudo apt-get update`
`sudo apt-get install unzip`
`unzip terraform_1.7.0_linux_amd64.zip`
`rm terraform_1.7.0_linux_amd64.zip`


Configure your main.tf and variables.tf
`cd <reponame>/<terraform folder>`
`code <terraform folder>`


**Secure File Transfer:**
    - [x] Utilize `sftp` for securely transferring credentials to the remote machine.

Download GCP Service account <GCP ProjectName>.json file:
```
Create a service account and obtain the credentials (JSON key file) for Google Cloud in the context of using Terraform

1. Navigate to the Google Cloud Console:
Open the Google Cloud Console.

2. Select or Create a Project:
Ensure that you are working within the correct project or create a new one.

3. Navigate to IAM & Admin > Service accounts:
In the left sidebar, go to "IAM & Admin" and then click on "Service accounts."

4. Create a Service Account:

Click on the "Create Service Account" button.
Provide a name and description for the service account.
Choose the appropriate role(s) that grant the necessary permissions for your Terraform operations. You might need roles like Editor or more specific roles depending on your use case.

5. Create a Key and Download JSON File:
After creating the service account, click on the service account's name.
Go to the "Keys" tab.
Click on the "Add Key" button and choose "JSON" as the key type.
This will download a JSON file containing the service account key to your local machine.


6. Set Environment Variable:

Open your terminal or command prompt.
Set the GOOGLE_APPLICATION_CREDENTIALS environment variable to point to the location of the downloaded JSON key file. This step is crucial for Terraform to use the correct credentials.

`export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/<GCP ProjectName>`
`gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS`
```

Go back to terminal of your local machine
`sftp <VMName>`

```
Connected to <VMName>.
sftp> ls
Anaconda3-2023.09-0-Linux-x86_64.sh     Anaconda3-2023.09-0-MacOSX-arm64.sh     
anaconda3                               bin                                     
<repoName                               snap                                    
sftp> mkdir .gc
sftp> cd .gc
sftp> ls
sftp> put <GCP ProjectName>.json
Uploading <GCP ProjectName>.json to /home/.gc/<GCP ProjectName>.json
<GCP ProjectName>.json     100% 2411   123.8KB/s   00:00    
sftp> Connection to <External IP> closed by remote host.
```

`ssh <VMName>`
`cd .gc/`
```
$ ls
<GCP ProjectName>.json
```


   - [x] Create infrastracture

`terraform init`
`terraform plan`
`terraform apply`


16. **Environment Cleanup:**
    - [x] Learn the process of shutting down and removing the GCP VM instance to manage resources effectively.
