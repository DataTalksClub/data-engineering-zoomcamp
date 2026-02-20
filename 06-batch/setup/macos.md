
## MacOS

> TODO: These instructions are for Spark 3.5.5. If you'd like to help update them for Spark 4.1.1,
> please submit a PR! See [windows.md](windows.md) and [linux.md](linux.md) for reference.

### Installing Java

Ensure Brew and Java are installed in your system:

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

Make sure Java was installed to `/usr/local/Cellar/openjdk@11/11.0.12`: Open Finder > Press Cmd+Shift+G > paste "/usr/local/Cellar/openjdk@11/11.0.12". If you can't find it, then change the path location to the appropriate path on your machine. You can also run `brew info java` to check where java was installed on your machine.


### PySpark

We recommend using [uv](https://docs.astral.sh/uv/) for managing Python packages:

```bash
uv init
uv add pyspark
```

Alternatively, you can use pip:

```bash
pip install pyspark
```

Both approaches install PySpark along with a bundled Spark distribution — no separate Spark download needed.


### Testing it

Regardless of the installation method above, the goal is to get this test script working.

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
