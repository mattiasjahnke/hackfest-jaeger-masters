const SerialPort = require('serialport')
const fetch = require('node-fetch')
const port = new SerialPort('/dev/cu.usbserial-14220', {
  baudRate: 9600
})

var heartbeat_bpm = 65
var pulseInterval;

const sendPulse = () => {
    port.write('0', function(err) {
        if (err) { return console.log('Error on write: ', err.message) }
    })
}

const setupPulseTimer = () => {
    if (pulseInterval !== undefined) {
        clearInterval(pulseInterval);
    }
    pulseInterval = setInterval(sendPulse, bpmToMs(heartbeat_bpm));
}

const fetchHeartbeatBpm = () => {
    fetch('https://hackfest-jaeger.herokuapp.com/')
    .then(res => res.json())
    .then(json => {
        const hb = parseInt(json.beat);
        console.log("Fetched new heartbeat: " + hb);
        heartbeat_bpm = hb;
        setupPulseTimer();
    });
}

const bpmToMs = (bpm) => {
    return 60000 / bpm
}

setInterval(fetchHeartbeatBpm, 10 * 1000);
setupPulseTimer();