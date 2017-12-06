var Connector = require('./src/index.js');
var request = require('request');

var headers = {
	'Content-Type': 'application/json'
};

var options = {
	url: 'http://localhost:1880/healthcare-demo/temp',
	method: 'POST',
	headers: headers

};

var device = {};
device['options'] = {};

var myConnector = new Connector();
myConnector.start(device, function(){console.log("start")});
myConnector.on('message', function(msg){
	options['form'] = {"value": msg.data.temperature}
	console.log(options['form']);
	request(options, function(err, res, body){
			if(!err && res.statusCode == 200)
				console.log("Success");
	})
	
})
