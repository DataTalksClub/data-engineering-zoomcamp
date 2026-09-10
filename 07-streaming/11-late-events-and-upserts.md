# Late events and upserts

The CSV producer sends events in order, so the watermark never has to
handle late arrivals. Let's use a real-time producer that generates
synthetic events with occasional delays to see what happens.


*A primary-key upsert lets a late event correct the published aggregate in place.*

Download and run the real-time producer:

```bash
PREFIX="https://raw.githubusercontent.com/DataTalksClub/data-engineering-zoomcamp/main/07-streaming/workshop"
wget ${PREFIX}/src/producers/producer_realtime.py -P src/producers/
```

```bash
uv run python src/producers/producer_realtime.py
```

It generates random taxi trips with current timestamps, but ~20% of events
are sent with a timestamp 3-10 seconds in the past (simulating network
delays). The output labels each event:

```
  on time   -> PU=79 ts=14:23:05
  on time   -> PU=107 ts=14:23:05
  LATE (8s) -> PU=234 ts=14:22:58
  on time   -> PU=48 ts=14:23:06
```

With our 5-second watermark and 1-hour windows, no events will be dropped -
even an event 10 seconds late lands well within the current hour window.
But the watermark + upsert behavior is still visible: Flink first emits
window results when the watermark passes the window end, then late events
update those results via the PRIMARY KEY.

To see this in action, open two terminals:

Terminal 1 - run the real-time producer:

```bash
uv run python src/producers/producer_realtime.py
```

Terminal 2 - watch aggregation counts change:

```bash
watch -n 1 'PGPASSWORD=postgres docker compose exec postgres psql -U postgres -d postgres -c "SELECT window_start, sum(num_trips) as trips, round(sum(total_revenue)::numeric, 2) as revenue FROM processed_events_aggregated GROUP BY window_start ORDER BY window_start;"'
```

You'll see the counts for older windows increase as late events arrive
and update the aggregation via upsert. This is why we set up the PRIMARY
KEY - without it, late events would either be dropped or create duplicates.
