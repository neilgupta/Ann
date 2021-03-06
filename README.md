# Ann

http://ann.metamorphium.com

Ann is an AI that collects sensor data from the environment to analyze and generate appropriate responses. It was built for the Cisco IoT 2014 Hackathon in Chicago, and can be used to automate and control various aspects of managing an event.

Ann uses the concept of sensor neurons as inputs, allowing you to plug in any data source, and motor neurons as outputs, allowing you to control any internet-connected device or service. For example, Ann can reply to tweets, make announcements, track movement, or control the lights.

Each output can be assigned its own personality, which is a set of rules for how to behave given an input. You may also want to look at [AnnCNS](https://github.com/neilgupta/AnnCNS), which allows a Raspberry Pi to send and receive data between Ann and a local Xbee network, and [SensorNeurons](https://github.com/neilgupta/SensorNeurons), a couple sample Arduino projects for collecting analog sensor data and passing it over xbee radios.

## Setup

1. Copy `env.sample`, save as `.env`, and fill in information.
2. `bundle install`
3. `rake db:create`
4. `rake db:migrate`
5. `foreman start -p 3000`

You will also want to set up a cron job to run `foreman run rake ann:weather` every 10 - 60 minutes and `rake ann:clock` every hour on the hour.

You'll also need to manually setup your brain and sensors because the UI is not yet implemented.

```bash
$ foreman run rails c
> brain = Brain.create!(name: 'IoT Hackathon', address: '\x00\x13\xA2\x00\x40\x68\x2F\xB6')
> motion1 = brain.sensors.create!(name: 'Entrance', address: '\x00\x13\xA2\x00\x40\x68\x2F\xC0', sensor_type: 'motion') # orange cable
> motion2 = brain.sensors.create!(name: 'Auditorium', address: '\x00\x13\xA2\x00\x40\x60\xCE\x3B', sensor_type: 'motion') # red cable
> monkey = brain.sensors.create!(name: 'Monkey', address: '\x00\x13\xA2\x00\x40\x68\x2E\x8C', sensor_type: 'monkey')
> weather = brain.sensors.create!(name: 'Weather', sensor_type: 'weather')
> twitter = brain.sensors.create!(name: '@AnnsBrain', sensor_type: 'twitter')
> flock1 = brain.motors.create!(name: 'Flock 1 (with sound)', address: '\x00\x13\xA2\x00\x40\x68\x2E\xA4', motor_type: 'flock', personality: 'Weather')
> flock2 = brain.motors.create!(name: 'Flock 2 (with sound)', address: '\x00\x13\xA2\x00\x40\x68\x2E\xD6', motor_type: 'flock', personality: 'Motion')
> flock3 = brain.motors.create!(name: 'Flock 3 (with sound)', address: '\x00\x13\xA2\x00\x40\xB4\x08\xF4', motor_type: 'flock', personality: 'Social')
> flock4 = brain.motors.create!(name: 'Flock 4 (with sound)', address: 'f2', motor_type: 'flock', personality: 'Motion')
> flock5 = brain.motors.create!(name: 'Flock 5', address: 'f2', motor_type: 'flock', personality: 'Api')
> flock6 = brain.motors.create!(name: 'Flock 6', address: 'f2', motor_type: 'flock', personality: 'Random')
```

## Credits

### Forecast.io

Hyper-local weather data is powered by [Forecast.io](http://forecast.io/).

*Note:* If you want to use their free developer account and check weather every 10 minutes, you will be limited to 6 concurrent weather sensors. Raising the refresh interval to hourly (which is perfectly reasonable) enables 41 active weather sensors. A paid developer account from Forecast.io has no limit.

### Twitter

Social interaction is powered by [Twitter](http://twitter.com) obviously.
