
## Linux

Here we'll show you how to install Spark 4.x for Linux.
We tested it on Ubuntu 24.04 (also WSL), but it should work
for other Linux distros as well


### Installing Java

Spark 4.x requires Java 17 or 21. The simplest way is to install it via your package manager:

```bash
sudo apt update
sudo apt install default-jdk
```

Check that it works:

```bash
java --version
```

Output (example):

```
openjdk 21.0.10 2026-01-20
OpenJDK Runtime Environment (build 21.0.10+7-Ubuntu-124.04)
OpenJDK 64-Bit Server VM (build 21.0.10+7-Ubuntu-124.04, mixed mode, sharing)
```

Set `JAVA_HOME` (add to your `.bashrc` or `.zshrc`):

```bash
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export PATH="${JAVA_HOME}/bin:${PATH}"
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

Both approaches install PySpark along with a bundled Spark distribution - no separate Spark download needed.

For other platforms, see [pyspark.md](pyspark.md).
