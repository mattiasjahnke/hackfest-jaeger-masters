const SerialPort = require('serialport')
const port = new SerialPort('/dev/cu.usbserial-14220', {
  baudRate: 9600
})

var heartbeat_bpm = 65

const sendPulse = () => {
    port.write('0', function(err) {
        if (err) { return console.log('Error on write: ', err.message) }
    })
}

const bpmToMs = (bpm) => {
    return 60000 / bpm
}

setInterval(sendPulse, bpmToMs(heartbeat_bpm));