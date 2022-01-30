## Airflow concepts


### Airflow architecture
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


### Project Structure:

* `./dags` - `DAG_FOLDER` for DAG files (use `./dags_local` for the local ingestion DAG)
* `./logs` - contains logs from task execution and scheduler.
* `./plugins` - for custom plugins


### Workflow components

* `DAG`: Directed acyclic graph, specifies the dependencies between a set of tasks with explicit execution order, and has a beginning as well as an end. (Hence, “acyclic”)
    * `DAG Structure`: DAG Definition, Tasks (eg. Operators), Task Dependencies (control flow: `>>` or `<<` )
    
* `Task`: a defined unit of work (aka, operators in Airflow). The Tasks themselves describe what to do, be it fetching data, running analysis, triggering other systems, or more.
    * Common Types: Operators (used in this workshop), Sensors, TaskFlow decorators
    * Sub-classes of Airflow's BaseOperator

* `DAG Run`: individual execution/run of a DAG
    * scheduled or triggered

* `Task Instance`: an individual run of a single task. Task instances also have an indicative state, which could be “running”, “success”, “failed”, “skipped”, “up for retry”, etc.
    * Ideally, a task should flow from `none`, to `scheduled`, to `queued`, to `running`, and finally to `success`.
