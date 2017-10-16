_ = require 'lodash'
fs = require 'fs'

class MeshbluConfig
  constructor: (@auth={}, options={}) ->
    @filename = options.filename ? './meshblu.json'
    @uuid_env_name = options.uuid_env_name ? 'MESHBLU_UUID'
    @token_env_name = options.token_env_name ? 'MESHBLU_TOKEN'
    @server_env_name = options.server_env_name ? 'MESHBLU_SERVER'
    @hostname_env_name = options.hostname_env_name ? 'MESHBLU_HOSTNAME'
    @port_env_name = options.port_env_name ? 'MESHBLU_PORT'
    @protocol_env_name = options.protocol_env_name ? 'MESHBLU_PROTOCOL'
    @private_key_env_name = options.private_key_env_name ? 'MESHBLU_PRIVATE_KEY'
    @resolve_srv_env_name = options.private_key_env_name ? 'MESHBLU_RESOLVE_SRV'

  parseMeshbluJSON: ->
    JSON.parse fs.readFileSync @filename

  toJSON: =>
    try meshbluJSON = @parseMeshbluJSON()
    meshbluJSON          ?= {}

    meshbluJSON = _.defaults @auth, {
      uuid: process.env[@uuid_env_name]
      token: process.env[@token_env_name]
      server: process.env[@server_env_name]
      hostname: process.env[@hostname_env_name]
      port: process.env[@port_env_name]
      protocol: process.env[@protocol_env_name]
      privateKey: process.env[@private_key_env_name]
      resolveSrv: process.env[@resolve_srv_env_name] == 'true'
    }, meshbluJSON

    meshbluJSON.server   ?= meshbluJSON.hostname
    meshbluJSON.hostname ?= meshbluJSON.server
    meshbluJSON.host     ?= "#{meshbluJSON.hostname}:#{meshbluJSON.port}" if meshbluJSON.hostname?
    return @compact meshbluJSON

  compact: (obj) =>
    compactedObj = {}

    _.each obj, (value, key) =>
      compactedObj[key] = value if value?
      compactedObj[key] = value.trim() if value?.trim?

    compactedObj

module.exports = MeshbluConfig
