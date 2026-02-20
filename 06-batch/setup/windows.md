## Windows

Here we'll show you how to install Spark 4.x for Windows.
We tested it on Windows 10 and 11, but it should work
for other versions as well.

In this tutorial, we'll use [MINGW](https://www.mingw-w64.org/)/[Git Bash](https://gitforwindows.org/) for the command line.

If you use WSL, follow the instructions from [linux.md](linux.md).


### Installing Java

Spark 4.x requires Java 17. Download and unpack the Adoptium JDK 17:

```bash
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.18%2B8/OpenJDK17U-jdk_x64_windows_hotspot_17.0.18_8.zip
unzip OpenJDK17U-jdk_x64_windows_hotspot_17.0.18_8.zip -d /c/tools/
```

The full path to JDK will be `/c/tools/jdk-17.0.18+8`.

Now let's configure it and add it to `PATH` (add to your `.bashrc`):

```bash
export JAVA_HOME="/c/tools/jdk-17.0.18+8"
export PATH="${JAVA_HOME}/bin:${PATH}"
```

Check that Java works correctly:

```bash
java --version
```

Output:

```
openjdk 17.0.18 2026-01-20 LTS
OpenJDK Runtime Environment Temurin-17.0.18+8 (build 17.0.18+8-LTS)
OpenJDK 64-Bit Server VM Temurin-17.0.18+8 (build 17.0.18+8-LTS, mixed mode, sharing)
```


### PySpark

We recommend using [uv](https://docs.astral.sh/uv/) for managing Python packages:

```bash
uv init
uv add pyspark
```

Then run your scripts with `uv run`:

```bash
uv run python your_script.py
```

Alternatively, you can use pip:

```bash
pip install pyspark
```

Both approaches install PySpark along with a bundled Spark distribution — no separate Spark or Hadoop download needed.

> If you previously installed Spark 3.x and have `SPARK_HOME` set in your `.bashrc` (e.g. pointing to `C:/tools/spark-3.3.2-bin-hadoop3`), remove that line. PySpark 4.x bundles its own Spark, so `SPARK_HOME` is no longer needed. If the old `SPARK_HOME` is still set, PySpark 4.x will load the old JARs and fail.


### Testing it

Create a test script `test_spark.py`:

```python
import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

print(f"Spark version: {spark.version}")

df = spark.range(10)
df.show()

spark.stop()
```

Run it:

```bash
uv run python test_spark.py
```

At this point you may get a message from Windows Firewall — allow it.

You may see a warning like `WARNING: Using incubator modules: jdk.incubator.vector` — you can safely ignore it.

