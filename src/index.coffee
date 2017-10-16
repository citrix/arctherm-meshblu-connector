{EventEmitter}      = require 'events'
debug               = require('debug')('meshblu-connector-arc-instatemp:index')
ArcInstaTempManager = require './arc-instatemp-md-manager'

class Connector extends EventEmitter
  constructor: ->
    @arcTemperature = new ArcInstaTempManager
    @arcTemperature.on 'data', @_onData

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    @arcTemperature.close callback

  onConfig: (device={}, callback=->) =>
    { @options } = device
    debug 'on config', @options
    { autoDiscover } = @options ? {}
    @arcTemperature.connect { autoDiscover }, callback

  _onData: (data) =>
    if data
        @emit 'message', {devices: ['*'], data}

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
