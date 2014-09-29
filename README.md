# Ann

http://ann.metamorphium.com



## Setup

1. Copy `env.sample`, save as `.env`, and fill in information.
2. `bundle install`
3. `foreman start -p 3000`

You will also want to set up a cron job to run `foreman run rake ann:weather` every 10 - 60 minutes.

## Credits

### Forecast.io

Hyper-local weather data is powered by [Forecast.io](http://forecast.io/).

*Note:* If you want to use their free developer account and check weather every 10 minutes, you will be limited to 6 concurrent weather sensors. Raising the refresh interval to hourly (which is perfectly reasonable) enables 41 active weather sensors. A paid developer account from Forecast.io has no limit.

### Twitter

Social interaction is powered by [Twitter](http://twitter.com) obviously.
