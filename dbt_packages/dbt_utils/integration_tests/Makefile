TARGETS = postgres redshift snowflake bigquery
.PHONY : test test-all $(TARGETS)

test: export TARGET = $(target)
test: export MODELS = $(models)
test: export SEEDS = $(seeds)
test:
	docker-compose -f ../docker-compose.yml up dbt

$(TARGETS):
	$(MAKE) test target=$@

test-all: $(TARGETS)
	echo "Tested all targets"
