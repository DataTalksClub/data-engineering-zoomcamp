
## MacOS

Here we'll show you how to install Spark 3.2.1 for MacOS.
We tested it on MacOS Monterey 12.0.1, but it should work
for other MacOS versions as well

### Installing Java

Ensure Brew and Java installed in your system:

```bash
xcode-select –install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew cask install java
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

Add the following environment variables to your `.bash_profile` or `.zshrc`

```bash
export SPARK_HOME=/usr/local/Cellar/apache-spark/3.2.1/libexec
export PATH="$SPARK_HOME/bin/:$PATH
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


