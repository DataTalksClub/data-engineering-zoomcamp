
## MacOs

Here we'll show you how to install Spark 3.2.1 for MacOs.
We tested it on MacOs Monterey 12.0.1, but it should work
for other MacOs versions as well

### Installing Java

Ensure Brew and Java installed in your system.

`xcode-select –install`

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

`brew cask install java`


### Installing and Setting Up Spark

1. Install Scala

`brew install scala@2.11`

2. Install Apache Spark

`brew install apache-spark`

3. Add Environment Variables: 
Add the following environment variables to your `.bash_profile` or `.zshrc`

`export SPARK_HOME=/usr/local/Cellar/apache-spark/3.2.1/libexec`           
`export PATH="$SPARK_HOME/bin/:$PATH`

4. Verify Installation

### Testing Spark

Execute `spark-shell` and run the following:

```scala
val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_ < 10).collect()
```







