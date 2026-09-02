
## MacOS

Here we'll show you how to install Spark 4.x for macOS.
We tested it on macOS 15 (Sequoia), but it should work
for other versions as well.


### Installing Java

Spark 4.x requires Java 17. Ensure [Homebrew](https://brew.sh/) is installed, then install OpenJDK 17:

```bash
brew install openjdk@17
```

Add the following environment variables to your `.zshrc` (or `.bash_profile`):

```bash
export JAVA_HOME=$(brew --prefix openjdk@17)
export PATH="$JAVA_HOME/bin:$PATH"
```

Check that Java works correctly:

```bash
java --version
```

Output (example):

```
openjdk 17.0.14 2026-01-21
OpenJDK Runtime Environment Homebrew (build 17.0.14+0)
OpenJDK 64-Bit Server VM Homebrew (build 17.0.14+0, mixed mode, sharing)
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

Both approaches install PySpark along with a bundled Spark distribution — no separate Spark download needed.

> If you previously installed Spark 3.x and have `SPARK_HOME` set in your `.zshrc` or `.bash_profile` (e.g. pointing to a local Spark directory), remove that line. PySpark 4.x bundles its own Spark, so `SPARK_HOME` is no longer needed. If the old `SPARK_HOME` is still set, PySpark 4.x will load the old JARs and fail.


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

You may see a warning like `WARNING: Using incubator modules: jdk.incubator.vector` — you can safely ignore it.
