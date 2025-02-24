## Windows

Here we'll show you how to install Spark 3.3.2 for Windows.
We tested it on Windows 10 and 11 Home edition, but it should work
for other versions distros as well

In this tutorial, we'll use [MINGW](https://www.mingw-w64.org/)/[Gitbash](https://gitforwindows.org/) for command line

If you use WSL, follow the instructions from [linux.md](linux.md) 


### Installing Java

Spark needs Java 11. Download it from here: [https://www.oracle.com/de/java/technologies/javase/jdk11-archive-downloads.html](https://www.oracle.com/de/java/technologies/javase/jdk11-archive-downloads.html). Select “Windows x64 Compressed Archive” (you may have to create an oracle account for that)

Unpack it to a folder with no space in the path. We use `C:/tools` - so the full path to JDK is `/c/tools/jdk-11.0.13`


Now let’s configure it and add it to `PATH`:

```bash
export JAVA_HOME="/c/tools/jdk-11.0.13"
export PATH="${JAVA_HOME}/bin:${PATH}"
```

Check that Java works correctly:

```bash
java --version
```

Output:

```
java 11.0.13 2021-10-19 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.13+10-LTS-370)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.13+10-LTS-370, mixed mode)
```

### Hadoop

Next, we need to have Hadoop binaries. 

We'll need Hadoop 3.2 which we'll get from [here](https://github.com/cdarlint/winutils/tree/master/hadoop-3.2.0).

Create a folder (`/c/tools/hadoop-3.2.0`) and put the files there 

```bash
HADOOP_VERSION="3.2.0"
PREFIX="https://raw.githubusercontent.com/cdarlint/winutils/master/hadoop-${HADOOP_VERSION}/bin/"

FILES="hadoop.dll hadoop.exp hadoop.lib hadoop.pdb libwinutils.lib winutils.exe winutils.pdb"

for FILE in ${FILES}; do
  wget "${PREFIX}/${FILE}"
done
```

If you don't have wget, you can use curl:

```bash
HADOOP_VERSION="3.2.0"
PREFIX="https://raw.githubusercontent.com/cdarlint/winutils/master/hadoop-${HADOOP_VERSION}/bin/"

FILES="hadoop.dll hadoop.exp hadoop.lib hadoop.pdb libwinutils.lib winutils.exe winutils.pdb"

for FILE in ${FILES}; do
  curl -o "${FILE}" "${PREFIX}/${FILE}";
done
```

Add it to `PATH`:

```bash
export HADOOP_HOME="/c/tools/hadoop-3.2.0"
export PATH="${HADOOP_HOME}/bin:${PATH}"
```

### Spark

Now download Spark. Select version 3.3.2 

```bash
wget https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz
```


Unpack it in some location without spaces, e.g. `c:/tools/`: 

```bash
tar xzfv spark-3.3.2-bin-hadoop3.tgz
```

Let's also add it to `PATH`:

```bash
export SPARK_HOME="/c/tools/spark-3.3.2-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"
```

### Testing it

Go to this directory

```bash
cd spark-3.3.2-bin-hadoop3
```

And run spark-shell:

```bash
./bin/spark-shell.cmd
```

At this point you may get a message from windows firewall — allow it.


There could be some warnings (like this):

```
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.spark.unsafe.Platform (file:/C:/tools/spark-3.3.2-bin-hadoop3/jars/spark-unsafe_2.12-3.3.2.jar) to constructor java.nio.DirectByteBuffer(long,int)
WARNING: Please consider reporting this to the maintainers of org.apache.spark.unsafe.Platform
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
```

You can safely ignore them.

Now let's run this:

```
val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_ < 10).collect()
```

### PySpark

It's the same for all platforms. Go to [pyspark.md](pyspark.md).

<details closed>
<summary><b>📖 Click to expand: Windows-specific PySpark Setup Guide</b></summary>

# 🚀 Complete Guide: Setting up PySpark in Windows

## 📋 Prerequisites
* ✅ Windows 10/11
* ✅ Python installed
* ✅ Administrative access

> ### 📂 Installation Location Note
> This guide uses `E:\Apps\tools` as the base installation directory. You can choose a different location:
> * `C:\Programs\tools`
> * `D:\Development\tools`
> * Or any other location
>
> ⚠️ **Requirements**:
> * Replace `E:\Apps\tools` with your preferred path
> * Avoid paths with spaces
> * Ensure write permissions
> * Update environment variables accordingly

## 🔨 Installation Steps

### 1️⃣ Java Setup
1. Download Java 11 from [Oracle](https://www.oracle.com/de/java/technologies/javase/jdk11-archive-downloads.html)
   * Select "Windows x64 Compressed Archive"
2. Extract to `E:\Apps\tools\jdk-11.0.13`
3. Set Environment Variables:
   ```powershell
   Variable name: JAVA_HOME
   Value: E:\Apps\tools\jdk-11.0.13
   ```
   ➕ Add to PATH: `%JAVA_HOME%\bin`

### 2️⃣ Hadoop Setup
1. Create directory: `E:\Apps\tools\hadoop-3.2.0`
2. Download Hadoop binaries:
   ```bash
   cd E:\Apps\tools\hadoop-3.2.0
   
   HADOOP_VERSION="3.2.0"
   PREFIX="https://raw.githubusercontent.com/cdarlint/winutils/master/hadoop-${HADOOP_VERSION}/bin/"
   FILES="hadoop.dll hadoop.exp hadoop.lib hadoop.pdb libwinutils.lib winutils.exe winutils.pdb"
   
   for FILE in ${FILES}; do
     curl -o "${FILE}" "${PREFIX}/${FILE}"
   done
   ```
3. Set Environment Variables:
   ```powershell
   Variable name: HADOOP_HOME
   Value: E:\Apps\tools\hadoop-3.2.0
   ```
   ➕ Add to PATH: `%HADOOP_HOME%\bin`

### 3️⃣ Spark Setup
1. Download Spark:
   ```bash
   wget https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz
   ```
2. Extract to `E:\Apps\tools\spark-3.3.2-bin-hadoop3`
3. Set Environment Variables:
   ```powershell
   Variable name: SPARK_HOME
   Value: E:\Apps\tools\spark-3.3.2-bin-hadoop3
   ```
   ➕ Add to PATH: `%SPARK_HOME%\bin`

### 4️⃣ PySpark Setup
1. Install Python packages:
   ```bash
   pip install pyspark jupyter notebook
   ```

2. Set Environment Variables:
   ```powershell
   # 🔵 Required:
   Variable name: PYTHONPATH
   Value: %SPARK_HOME%\python;%SPARK_HOME%\python\lib\py4j-0.10.9.5-src.zip

   # 🟡 Optional (for Jupyter integration):
   Variable name: PYSPARK_DRIVER_PYTHON
   Value: jupyter
   
   Variable name: PYSPARK_DRIVER_PYTHON_OPTS
   Value: notebook
   ```

   > 💡 **Tip**: The Jupyter variables are optional. Set them only if you want PySpark to launch with Jupyter Notebook.

## ✅ Verification

### Method A: Python Interpreter
```powershell
# Launch Python
python
```
```python
# Test code
import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

# Create test dataframe
data = [("John", 30), ("Alice", 25)]
df = spark.createDataFrame(data, ["Name", "Age"])
df.show()
```

### Method B: VS Code Jupyter
1. Open VS Code
2. `Ctrl+Shift+P` → "Create New Jupyter Notebook"
3. Select Python kernel
4. Paste and run the test code above

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| `ModuleNotFoundError: No module named 'py4j'` | Check py4j version in `%SPARK_HOME%\python\lib` |
| Windows Firewall alerts | Allow access when prompted |
| Java version issues | Run `java -version` and verify `JAVA_HOME` |

## 📊 Sample Data Test
```python
# Get test data
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv

# Load and display
df = spark.read.option("header", "true").csv('taxi_zone_lookup.csv')
df.show()

# Test write
df.write.parquet('zones')
```

## 🔄 Manual Environment Setup

### System Variables
1. Open System Properties:
   * `Win + X` → System
   * Advanced system settings
   * Environment Variables

2. Add System Variables:
   ```powershell
   JAVA_HOME    = E:\Apps\tools\jdk-11.0.13
   HADOOP_HOME  = E:\Apps\tools\hadoop-3.2.0
   SPARK_HOME   = E:\Apps\tools\spark-3.3.2-bin-hadoop3
   PYTHONPATH   = %SPARK_HOME%\python;%SPARK_HOME%\python\lib\py4j-0.10.9.5-src.zip
   ```

3. Update PATH:
   ```
   %JAVA_HOME%\bin
   %HADOOP_HOME%\bin
   %SPARK_HOME%\bin
   ```

4. ↻ Restart terminals and IDEs

> 💡 **Final Tip**: Keep this guide bookmarked for future reference!


</details>
