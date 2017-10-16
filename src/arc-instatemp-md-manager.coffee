_              = require 'lodash'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-connector-arc-instatemp:arc-instatemp-md-manager')

if process.env.SKIP_REQUIRE_NOBLE == 'true'
  noble = new EventEmitter
else
  try
    noble = require 'noble'
  catch error
    console.error error

ON_STATE                  = 'poweredOn'
_DEVICE_NAME = ''
_FOUND_TEMP = false

class ArcInstaTempManager extends EventEmitter
  constructor: ->
    @noble = noble
    {@state} = @noble
    @noble.on 'discover', @_onDiscover
    @noble.on 'stateChange', @_onStateChange
    setInterval ->
        if _FOUND_TEMP
            _DEVICE_NAME = ''
            _FOUND_TEMP = false
    , 20000

  close: (callback=->) =>
    @_stopScanning()
    @_disconnect()
    callback()

  connect: ({@autoDiscover}, callback) =>
    @_emit = _.throttle @emit, 500, {leading: true, trailing: false}
    @_startScanning()
    callback()

  _disconnect: (callback=->) =>
    callback()

  _onData: (rawData) =>
    @_emit 'data', temperature: rawData

  _onDisconnect: =>
    @_disconnect =>
      @_startScanning()

  _onDiscover: (peripheral) =>
    debug 'discovered', peripheral.advertisement.localName
    temp = peripheral.advertisement.localName
    
    regExPattern = /ARC\:0057 ([0-9]+\.[0-9])(C|F)/
    matches = regExPattern.exec(temp)
    
    if matches
        foundTemp = matches[1]
        suffixTemp = matches[2]
        if temp != _DEVICE_NAME
            _DEVICE_NAME = temp
            _FOUND_TEMP = true
            foundTemp = @_c2f foundTemp
            debug 'temperature: ', foundTemp + suffixTemp
            @_onData foundTemp + suffixTemp

  _onStateChange: (@state) =>
    @_startScanning()

  _startScanning: =>
    return unless @state == ON_STATE
    @_disconnect =>
      @noble.startScanning [] , true

  _stopScanning: =>
    @noble.stopScanning()
    
  _c2f: (data) =>
    cel = parseFloat(data)
    #fahrenheit = cel * 1.8 + 32
    #return fahrenheit + "F"
    return cel

module.exports = ArcInstaTempManager
