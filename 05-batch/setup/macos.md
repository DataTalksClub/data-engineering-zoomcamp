
## MacOS

Here we'll show you how to install Spark 3.2.1 for MacOS.
We tested it on MacOS Monterey 12.0.1, but it should work
for other MacOS versions as well

### Installing Java

Ensure Brew and Java installed in your system:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install java
```

Add the following environment variables to your `.bash_profile` or `.zshrc`:

```bash
export JAVA_HOME=/usr/local/Cellar/openjdk@11/11.0.12
export PATH="$JAVA_HOME/bin/:$PATH"
```

Make sure Java was installed to `/usr/local/Cellar/openjdk@11/11.0.12`: Open Finder > Press Cmd+Shift+G > paste "/usr/local/Cellar/openjdk@11/11.0.12". If you can't find it, then change the path location to appropriate path on your machine. You can also run `brew info java` to check where java was installed on your machine.

### Anaconda-based spark set up
if you are having anaconda setup, you can skip the spark installation and instead Pyspark package to run the spark.
With Anaconda and Mac we can spark set by first installing pyspark and then for environment variable set up findspark

Open Anaconda Activate the environment where you want to apply these changes

Run pyspark and install it as a package in this environment <br>
Run findspark and install it as a package in this environment

Ensure that open JDK is already set up. This allows us to not have to install Spark separately and manually set up the environment Also with this we may have to use Jupyter Lab (instead of Jupyter Notebook) to open a Jupyter notebook for running the programs. 
Once the Spark is set up start the conda environment and open Jupyter Lab. 
Run the program below in notebook to check everything is running fine.
```
import pyspark
from pyspark.sql import SparkSession

!spark-shell --version

# Create SparkSession
spark = SparkSession.builder.master("local[1]") \
                    .appName('test-spark') \
                    .getOrCreate()

print(f'The PySpark {spark.version} version is running...')
```
### Installing Spark

1. Install Scala

```bash
brew install scala@2.11
```

2. Install Apache Spark

```bash
brew install apache-spark
```

3. Add environment variables: 

Add the following environment variables to your `.bash_profile` or `.zshrc`. Replace the path to `SPARK_HOME` to the path on your own host. Run `brew info apache-spark` to get this.

```bash
export SPARK_HOME=/usr/local/Cellar/apache-spark/3.2.1/libexec
export PATH="$SPARK_HOME/bin/:$PATH"
```


### Testing Spark

Execute `spark-shell` and run the following in scala:

```scala
val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_ < 10).collect()
```


### PySpark

It's the same for all platforms. Go to [pyspark.md](pyspark.md). 



