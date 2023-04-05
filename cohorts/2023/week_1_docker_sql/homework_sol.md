# Week 1 Homework

## Question 1: Knowing Docker tags

Run the command to get information on Docker:

\`\`\`
docker --help
\`\`\`

Now, run the command to get help on the "docker build" command:

\`\`\`
docker build --help
\`\`\`

Which tag has the following text? - Write the image ID to the file

- [ ] --imageid string
- [x] --iidfile string
- [ ] --idimage string
- [ ] --idfile string

## Question 2: Understanding Docker first run

Run Docker with the python:3.9 image in an interactive mode and the entrypoint of bash. Now, check the Python modules that are installed (use \`pip list\`). How many Python packages/modules are installed?

   ```bash
   docker run -it --entrypoint bash python:3.9

   ```sh
   pip list

- [ ] 1
- [ ] 6
- [x] 3
- [ ] 7

# Exercise: Prepare Postgres

## Dataset Preparation

1. Download the green taxi trips from January 2019:
3. Load data into Postgres (using Jupyter notebooks or a pipeline)

## Question 3: Count Records

### How many taxi trips were totally made on January 15?

- 20689
- 20530
- 17630
- 21090

_Answer:_

## Question 4: Largest Trip for Each Day

### Which was the day with the largest trip distance? Use the pick up time for your calculations.

- 2019-01-18
- 2019-01-28
- 2019-01-15
- 2019-01-10

_Answer:_

## Question 5: The Number of Passengers

### In 2019-01-01, how many trips had 2 and 3 passengers?

- 2: 1282 ; 3: 266
- 2: 1532 ; 3: 126
- 2: 1282 ; 3: 254
- 2: 1282 ; 3: 274

_Answer:_

## Question 6: Largest Tip

### For the passengers picked up in the Astoria Zone, which was the drop-off zone that had the largest tip? We want the name of the zone, not the id.

- Central Park
- Jamaica
- South Ozone Park
- Long Island City/Queens Plaza

_Answer:_
