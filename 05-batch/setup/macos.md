
## MacOS

Here we'll show you how to install Spark 3.5.5 for MacOS.
We tested it on MacOS Monterey 12.0.1, but it should work
for other MacOS versions as well

### Anaconda-based Spark set up

If you are having anaconda setup, you can skip the spark installation and instead Pyspark package to run the spark.

#### Installing Java

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

#### Anaconda

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

### Homebrew-based Spark set up
#### Installing Spark

1. Install Apache Spark. Java and Scala will be installed as Spark's dependencies.

```bash
brew install apache-spark
```

2. Copy openjdk and apache-spark paths from installation output.

You may see something like this in your terminal after the installation is complete:
```
==> Pouring openjdk@17--17.0.14.arm64_sequoia.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/openjdk@17/17.0.14: 636 files, 304.2MB
...
==> Pouring apache-spark--3.5.5.all.bottle.tar.gz
🍺  /opt/homebrew/Cellar/apache-spark/3.5.5: 1,823 files, 423.7MB
```

3. Add environment variables: 

Add the following environment variables to your `.bash_profile` or `.zshrc`. Replace the path to `JAVA_HOME` and `SPARK_HOME` to the paths on your own host. Run `brew info apache-spark` to get this.

```bash
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.14
export PATH="$JAVA_HOME/bin/:$PATH"

export SPARK_HOME=/opt/homebrew/Cellar/apache-spark/3.5.5/libexec
export PATH="$SPARK_HOME/bin/:$PATH"
```


#### Testing Spark

Execute `spark-shell` and run the following in scala:

```scala
val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_ < 10).collect()
```


### PySpark

It's the same for all platforms. Go to [pyspark.md](pyspark.md). 



