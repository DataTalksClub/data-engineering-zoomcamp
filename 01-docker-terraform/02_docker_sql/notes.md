### Docker Lecture 1.2.1

General introduction to containerization. Below are some key points:
- `Dockerfile` is going to contain all the necessary information for container build
- Run the following in location with `Dockerfile` to install and establish: ` docker build -t test:pandas .`
- And then to actually run something like a docker pipeline you'd do the following:
```bash
 docker run -it test:pandas 2024-10-10
```
- the above indicates we want to run the `test:pandas` container we built in `interactive` mode. 
- it seems like `interactive` mode is going to allow us to then pass in command, such as `2024-10-10` which would just indicate the date of file to execute on
- The output in this example was as follow:
```bash
['pipeline.py', '2024-10-10']
job finished successfully for day = 2024-10-10 
```