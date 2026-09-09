---
video_url: https://www.youtube.com/watch?v=hqUbB9c8sKg
---
# Installing Spark

This unit walks through installing Spark on Linux, on the cloud virtual
machine from week one - the same steps work on plain Linux and on the
Windows Subsystem for Linux. The video shows a manual install of Spark
3.0.3; the written guides in the Materials section below take a simpler
route with Spark 4.x, where installing the `pyspark` pip package brings
a bundled Spark with it.

## Installing Java

Spark runs on the JVM, so first we install Java. For Spark 3.0.3 we
need JDK 8 or 11 - the current JDK at the time, 17, does not work with
it, so we take an older one. The download page lists all versions; we
pick 11 and choose the Linux build. For Windows there is a separate
guide, and there it is better to use the Oracle JDK; on Linux OpenJDK
is fine.

We create a `spark` folder in the home directory and download the
OpenJDK archive there:

```bash
mkdir ~/spark
cd ~/spark
wget <the openjdk 11 link copied from the download page>
tar xzf <the archive>
rm <the archive>
```

This gives us a `jdk-11.0.1` directory. Now we set two environment
variables. `JAVA_HOME` must be called exactly that - Spark's scripts
look for it. Use `$HOME` instead of `~`: both mean the same, but
`$HOME` usually works better in scripts.

```bash
export JAVA_HOME=$HOME/spark/jdk-11.0.1
export PATH=$JAVA_HOME/bin:$PATH
```

Check that it works:

```bash
which java
java --version
```

The version should be 11.0.1 - an old version, as intended.

## Installing Spark

Next, Spark itself. Go to the Spark downloads page and pick release
3.0.3. The reason for this older release is that it works well on
Windows; if you feel adventurous you can try a more recent one, but it
is not guaranteed to work. For the package type choose "Pre-built for
Apache Hadoop 3.2" - again mostly important for Windows users, but it
keeps everyone consistent.

Click the download link, then download it with `wget` on the remote
machine. Careful here: in the video the first mirror serves a broken
archive, and the download has to be redone from a different mirror.
After unpacking we get a `spark-3.0.3-bin-hadoop3.2` directory, and we
do the same as with Java:

```bash
tar xzf spark-3.0.3-bin-hadoop3.2.tgz
rm spark-3.0.3-bin-hadoop3.2.tgz
export SPARK_HOME=$HOME/spark/spark-3.0.3-bin-hadoop3.2
export PATH=$SPARK_HOME/bin:$PATH
```

## Testing with spark-shell

Now we can check that everything works. Start the Spark shell:

```bash
spark-shell
```

You will see some warnings - they can be ignored. The Spark shell runs
Scala code. Let's test it with a small job:

```scala
val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_ < 10).collect()
```

The shell returns the values from 1 through 9:

```text
res0: Array[Int] = Array(1, 2, 3, 4, 5, 6, 7, 8, 9)
```

Here `data` is a range of numbers from 1 to 10000. `parallelize` turns
it into an RDD - a thing internal to Spark, a distributed collection.
The data becomes parallel: it now lives on the cluster (which in our
case is just this one machine). Then we look at all the numbers and
keep only the ones below 10, and `collect` brings the results back. The
output is the numbers 1 to 9 - a simple Spark job to confirm things
work.

## Making the variables permanent

We don't want to type these exports every time we log in. Open
`~/.bashrc` with an editor like `nano`, paste the four `export` lines
at the end, save, and exit. Then either re-evaluate the file:

```bash
source ~/.bashrc
```

or simply disconnect and connect to the machine again. Now `which java`
and `which spark-shell` both find their binaries - the variables are
set every time we open a terminal.

## Running PySpark

For PySpark we create a `notebooks` folder and start Jupyter there.
Because this is a remote machine, we forward port 8888 - in VS Code,
open the terminal with `` ctrl+` `` and use the Ports tab to forward
8888, the port Jupyter uses.

Before starting Jupyter, we need to tell Python where PySpark lives.
Run these exports from the setup instructions first:

```bash
export PYTHONPATH="$SPARK_HOME/python/:$PYTHONPATH"
export PYTHONPATH="$SPARK_HOME/python/lib/py4j-0.10.9-src.zip:$PYTHONPATH"
```

`PYTHONPATH` is like `PATH`, but for Python: it tells Python where to
look for packages. The first line adds `$SPARK_HOME/python`, where
PySpark lives. The second adds the extra dependencies PySpark needs.
Without these, `import pyspark` will not work.

Now start Jupyter, create a notebook, and check the import:

```python
import pyspark
pyspark.__file__
```

This points to the Spark directory we just installed. Then:

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()
```

The SparkSession is the thing that tells us how exactly we connect to
Spark. With `master("local[*]")` we create a local cluster: the master
is what coordinates the jobs of a Spark cluster, `local` means it runs
on this machine, and `*` means use all available CPUs - we could also
say `local[2]` for two CPUs. `getOrCreate` returns the existing session
or creates a new one if there isn't one. The same warnings as before
appear, and we ignore them again.

## Reading a CSV and writing parquet

Let's do something real. Download the taxi zone lookup file - you have
seen it in previous weeks - and read it with Spark:

```python
df = spark.read.csv('taxi+_zone_lookup.csv')
df.show()
```

Looking at the output, Spark did not understand that `LocationID`,
`Borough` and the rest are the headers of the CSV file - the columns
get names that don't make much sense. We need to tell it to load the
header:

```python
df = spark.read \
    .option("header", "true") \
    .csv('taxi+_zone_lookup.csv')
df.show()
```

Now the column names are right. Let's save it as parquet:

```python
df.write.parquet('zones')
```

The job is so fast we can barely see the progress. If we look at the
folder, `zones` is not a file but a directory, and inside there are two
things: the parquet file itself and a `_SUCCESS` file, which marks the
job as successful.

## The Spark UI

One more thing before we finish: forward another port, 4040, and open
localhost:4040 in your browser. This is the interface of the Spark
master - it shows all the jobs we executed, and we will use it
throughout the module to see what exactly Spark is doing. If you run
Spark locally you don't need to forward anything: the moment Spark
starts, it starts the local master, and the UI is right there on that
port.

That is the Linux install. For Windows the steps are similar, plus a
Hadoop section that Linux doesn't need. For Mac, the Linux guide will
probably work without problems. In the next video we write our first
PySpark application and test it with the high-volume FHV taxi dataset
for January 2021.

## Materials

The video walks through the Linux install and is marked optional in the module
README. The written guides cover all three platforms:

* [Windows](setup/windows.md)
* [Linux](setup/linux.md)
* [MacOS](setup/macos.md)

Alternatively, if the setups above don't work, you can run Spark in Google Colab.

> [!NOTE]
> It's advisable to invest some time in setting things up locally rather than immediately jumping into this solution

* [Google Colab Instructions](https://medium.com/gitconnected/launch-spark-on-google-colab-and-connect-to-sparkui-342cad19b304)
* [Google Colab Starter Notebook](https://github.com/aaalexlit/medium_articles/blob/main/Spark_in_Colab.ipynb)

Spark on YARN, needed for the Spark-and-Docker material rather than for this
unit, has its own guide: [Hadoop and YARN](setup/hadoop-yarn.md).
