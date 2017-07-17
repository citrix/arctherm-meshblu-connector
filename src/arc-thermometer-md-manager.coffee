_ = require 'lodash'
{EventEmitter} = require 'events'
debug = require('debug')('meshblu-connector-arc-thermometer:arc-thermometer-md-manager')

if process.env.SKIP_REQUIRE_NOBLE == 'true'
  noble = new EventEmitter
else
  try
    noble = require 'noble'
  catch error
    console.error error


ON_STATE = 'poweredOn'
DATA_UUID = '2456e1b926e28f83e744f34f01e9d703'
DEVICE_STARTING_NAME = /ARC\:/i
dataCharacteristic = null
completeData = ''
CONNECTED_TO_DEVICE = false

class ArcThermometerManager extends EventEmitter
  constructor: ->
    @noble = noble
    {@state} = @noble
    @noble.on 'discover', @_onDiscover
    @noble.on 'stateChange', @_onStateChange

  close: (callback = ->) =>
    @_stopScanning()
    @_disconnect()
    callback()

  connect: ({@autoDiscover, @localName}, callback) =>
    @_emit = _.throttle @emit, 500, {leading: true, trailing: false}
    @_startScanning()
    callback()

  _disconnect: (callback = ->) =>
    
    dataCharacteristic = null
    completeData = ''
    CONNECTED_TO_DEVICE = false
    
    if @peripheral?
      @peripheral?.disconnect()
      delete @peripheral

    if @characteristic?
      @characteristic.removeAllListeners 'data'
      delete @characteristic

    callback()

  _onData: (data) =>
    debug data
    @_emit 'data', temperature: data

  _onDisconnect: =>
    @_disconnect =>
      @_startScanning()

  _onDiscover: (peripheral) =>
    debug 'discovered', peripheral?.advertisement?.localName

    peripheralName = peripheral.advertisement.localName

    if DEVICE_STARTING_NAME.test(peripheralName) && !CONNECTED_TO_DEVICE
      dataCharacteristic = null
      completeData = ''
      CONNECTED_TO_DEVICE = true
      @_stopScanning()
      debug 'Found device', peripheralName
      peripheral.connect (error) =>
        return if error?
        @_onPeripheral peripheral, (error) =>
          return @_disconnect() if error?

  _onPeripheral: (@peripheral, callback) =>
    debug 'Connected'
    @peripheral.discoverServices [], (error, services) =>
      return callback error if error?
      _.each services, (service) =>
        @_characteristicsDiscovery service, @peripheral
      @_stopScanning()
      @peripheral.once 'disconnect', @_onDisconnect

  _characteristicsDiscovery: (service, @peripheral) =>
    service.discoverCharacteristics [], (error, characteristics) =>
      _.each characteristics, (c) =>
        switch c.uuid
          when DATA_UUID then dataCharacteristic = c

      if dataCharacteristic
        dataCharacteristic.on 'notify', (state) =>
            debug "dataCharacteristic notify is : ", state ? "on" : "off"

        dataCharacteristic.on 'data', (data, isNotification) =>
          if data
            data = data.toString('hex')
            completeData += data
            if /640a/.test(data)
              decodedData = @_hex2a completeData
              decodedData = decodedData.split(",")
              debug decodedData[13]
              celsius = parseFloat(decodedData[13])
              fahrenheit = @_c2f celsius
              @_onData {celsius: celsius, fahrenheit: fahrenheit}
              completeData = ''


        dataCharacteristic.notify true, (error) =>
            debug 'data channel notification on'

  _onStateChange: (@state) =>
    @_startScanning()

  _startScanning: =>
    return unless @state == ON_STATE
    @_disconnect =>
      @noble.startScanning [], true

  _stopScanning: =>
    @noble.stopScanning()

  _hex2a: (hexx) =>
    hex = hexx.toString()
    str = '';
    i = 0
    while i < hex.length
      str += String.fromCharCode(parseInt(hex.substr(i, 2), 16))
      i += 2
    return str

  _c2f: (data) =>
    cel = parseFloat(data)
    fahrenheit = cel * 1.8 + 32
    return fahrenheit

module.exports = ArcThermometerManager
