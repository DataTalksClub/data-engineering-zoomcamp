from datetime import timedelta
import faust
from taxi_rides import TaxiRide


app = faust.App('datatalksclub.stream.v2', broker='kafka://localhost:9092')
topic = app.topic('datatalkclub.yellow_taxi_ride.json', value_type=TaxiRide)

vendor_rides = app.Table('vendor_rides_windowed', default=int).tumbling(
    timedelta(minutes=1),
    expires=timedelta(hours=1),
)


@app.agent(topic)
async def process(stream):
    async for event in stream.group_by(TaxiRide.vendorId):
        vendor_rides[event.vendorId] += 1


if __name__ == '__main__':
    app.main()
