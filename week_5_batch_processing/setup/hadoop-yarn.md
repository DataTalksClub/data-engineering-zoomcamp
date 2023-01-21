## Spark on YARN 

For the Spark and Docker module, we need YARN, which
comes together with Hadoop. So we need to install Hadoop

In this document, we'll assume you use Linux. For Windows, use WSL. It should work (supposedly) on MacOS as well. 

We'll need to run it in a pseudo-distributed mode.


### Configuring ssh

You need to run be able to `ssh` to your localhost without having to type any password. In other words, you execute 

```bash
ssh localhost
```

And you get ssh access. 

If you don't have it, add your `id_rsa.pub` key to the list of keys authorized to access your computer:

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

(This assumes you already have `id_rsa.pub` in `~/.ssh`)

On WSL, you may need to start the ssh service:

```bash
sudo service ssh start
```

### Download Hadoop binaries

We use Spark that expects Hadoop 3.2 version. So we'll install it.

Go to the [Hadoop's website](https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz) to get the closest mirrow. And then download it:

```bash
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz
```

Unpack it and go to this directory

```bash
tar xzfv hadoop-3.2.3.tar.gz
cd hadoop-3.2.3/
```


### YARN on a Single Node

Set `JAVA_HOME` in `etc/hadoop/hadoop-env.sh`:

```bash
echo "export JAVA_HOME=${JAVA_HOME}" >> etc/hadoop/hadoop-env.sh
```

Start YARN

```bash
./sbin/start-yarn.sh
```

YARN should work on port 8088: http://localhost:8088/


### Running Spark on YARN

For submitting spark jobs, we'll need to use `master="yarn"`.

Spark needs to know where to look for YARN config files, so we need to set it:


```bash
export HADOOP_HOME="${HOME}/spark/hadoop-3.2.3"
export YARN_CONF_DIR="${HADOOP_HOME}/etc/hadoop"
```

Then run Jupyter or use spark-submit.


### Connecting Spark and YARN to GCS

Download the GCS connector:

```bash
gsutil cp gs://hadoop-lib/gcs/gcs-connector-hadoop3-2.2.5.jar .
```

Config changes:

* Change `${SPARK_HOME}/conf/spark-defaults.conf` (see [here]())
* Change `${YARN_CONF_DIR}/core-site.xml` (see [here](config/core-site.xml))

Template for hadoop properties:

```xml
  <property>
    <name></name>
    <value></value>
  </property>
```

### Spark and YARN with Docker

Copy the config from [here](https://hadoop.apache.org/docs/r3.2.3/hadoop-yarn/hadoop-yarn-site/DockerContainers.html)

Running spark-submit:

```bash
MOUNTS="$HADOOP_HOME:$HADOOP_HOME:ro,/etc/passwd:/etc/passwd:ro,/etc/group:/etc/group:ro"
IMAGE_ID="pyspark-docker:test"

spark-submit \
    --master yarn \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_TYPE=docker \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_DOCKER_IMAGE=${IMAGE_ID} \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_TYPE=docker \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_DOCKER_IMAGE=${IMAGE_ID} \
    06_spark_sql.py \
        --input_green=gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/green/2021/*/ \
        --input_yellow=gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/yellow/2021/*/ \
        --output=gs://dtc_data_lake_de-zoomcamp-nytaxi/report-2021
```



### Sources

* https://hadoop.apache.org/docs/r3.2.3/hadoop-project-dist/hadoop-common/SingleCluster.html
* https://spark.apache.org/docs/latest/configuration.html#custom-hadoophive-configuration
