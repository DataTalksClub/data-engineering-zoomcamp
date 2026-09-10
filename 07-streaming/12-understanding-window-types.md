# Understanding window types

We used tumbling windows above. Flink supports three types:


*The window type determines whether an event belongs to one fixed bucket, several overlapping buckets, or a burst bounded by inactivity.*

## Tumbling windows
Fixed-size, non-overlapping. Every event belongs to exactly one window.
If you come from the batch world, tumbling windows are the most familiar -
they just cut up your data into fixed segments. It's essentially a way to
speed up batch processing.

```
|  Window 1  |  Window 2  |  Window 3  |
|  1 hour    |  1 hour    |  1 hour    |
```

Use case: Counting trips per hour, daily revenue summaries.

## Sliding windows
Fixed-size, overlapping. An event can belong to multiple windows. When you
think of a 1-hour window, most people think of 00:00-01:00. But there's
also 00:15-01:15, 00:30-01:30 - those are also 1-hour windows, just
starting at different points. Sliding windows capture all of them.

```
|--- Window 1 (1 hour) ---|
      |--- Window 2 (1 hour) ---|
            |--- Window 3 (1 hour) ---|
      <- 15 min slide ->
```

```sql
HOP(TABLE events, DESCRIPTOR(event_timestamp), INTERVAL '15' MINUTE, INTERVAL '1' HOUR)
```

Use case: finding peaks and valleys - "what was our peak traffic in any
1-hour window?" These overlapping windows let you find the moment in time
where you have the highest or lowest values. Good for min-maxing, moving
averages, and surge detection (e.g., ride-share surge pricing).

## Session windows
Dynamic windows based on inactivity gaps. Unlike tumbling and sliding
windows, the window size isn't fixed - the window doesn't close at a
specified time, it closes after a specified amount of inactivity.

```
|--events--| gap |--events------| gap |--events--|
| Session 1|     |  Session 2   |     | Session 3|
```

Use case: grouping user behavior together. Imagine a user logs into an app,
clicks a bunch of buttons, leaves for 2 minutes, then comes back - that's
still technically the same session. You set a session gap (say, 30 minutes
of inactivity) and Flink groups all the events within that session together.
Sessionization is very powerful for behavioral analytics.
