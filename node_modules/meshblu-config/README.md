# meshblu-config
Meshblu Config from environment or JSON file

## Install

```bash
npm install meshblu-config
```

## Usage

```js
var MeshbluConfig = require('meshblu-config');
var meshbluConfig = new MeshbluConfig({});

var Meshblu = require('meshblu');
var meshblu = Meshblu.createConnection(meshbluConfig.toJSON());
```

## Options (showing default values)

```js
{
  filename: './meshblu.json',
  uuid_env_name: process.env.MESHBLU_UUID,
  token_env_name: process.env.MESHBLU_TOKEN,
  server_env_name: process.env.MESHBLU_SERVER,
  port_env_name: process.env.MESHBLU_PORT
}
```
