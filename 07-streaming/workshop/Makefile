.PHONY: build up down job aggregation_job stop start

build:
	docker compose build

up:
	docker compose up --build --remove-orphans -d

down:
	docker compose down --remove-orphans

job:
	docker compose exec jobmanager ./bin/flink run -py /opt/src/job/start_job.py --pyFiles /opt/src -d

aggregation_job:
	docker compose exec jobmanager ./bin/flink run -py /opt/src/job/aggregation_job.py --pyFiles /opt/src -d

stop:
	docker compose stop

start:
	docker compose start
