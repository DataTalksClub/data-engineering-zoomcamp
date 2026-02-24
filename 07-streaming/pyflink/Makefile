PLATFORM ?= linux/amd64

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


TARGET_MAX_CHAR_NUM=20

## Show help with `make help`
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.PHONY: build
## Builds the Flink base image with pyFlink and connectors installed
build:
	docker build .

.PHONY: up
## Builds the base Docker image and starts Flink cluster
up:
	docker compose up --build --remove-orphans  -d

.PHONY: down
## Shuts down the Flink cluster
down:
	docker compose down --remove-orphans

.PHONY: job
## Submit the Flink job
job:
	docker compose exec jobmanager ./bin/flink run -py /opt/src/job/start_job.py --pyFiles /opt/src -d

aggregation_job:
	docker compose exec jobmanager ./bin/flink run -py /opt/src/job/aggregation_job.py --pyFiles /opt/src -d

.PHONY: stop
## Stops all services in Docker compose
stop:
	docker compose stop

.PHONY: start
## Starts all services in Docker compose
start:
	docker compose start
