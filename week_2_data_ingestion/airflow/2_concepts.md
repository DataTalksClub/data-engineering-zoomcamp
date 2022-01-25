### Concepts

#### Airflow architecture
![](arch-diag-basic.png)

Ref: https://airflow.apache.org/docs/apache-airflow/stable/concepts/overview.html

* **Web server**:
GUI to inspect, trigger and debug the behaviour of DAGs and tasks. 
Available at http://localhost:8080.

* **Scheduler**:
Responsible for scheduling jobs. Handles both triggering & scheduled workflows, submits Tasks to the executor to run, monitors all tasks and DAGs, and
then triggers the task instances once their dependencies are complete.

* **Worker**:
This component executes the tasks given by the scheduler.

* **Metadata database (postgres)**:
Backend to the Airflow environment. Used by the scheduler, executor and webserver to store state.

* **Other components** (seen in docker-compose services):
    * `redis`: Message broker that forwards messages from scheduler to worker.
    * `flower`: The flower app for monitoring the environment. It is available at http://localhost:5555.
    * `airflow-init`: initialization service (customized as per this design)

All these services allow you to run Airflow with CeleryExecutor. 
For more information, see [Architecture Overview](https://airflow.apache.org/docs/apache-airflow/stable/concepts/overview.html).

Directories:
* `./dags` - `DAG_FOLDER` for DAG files
* `./logs` - contains logs from task execution and scheduler.
* `./plugins` - for custom plugins
