'use strict'

var Alexa = require('alexa-sdk');
var request = require('request');

exports.handler = function(event, context, callback) {
  var alexa = Alexa.handler(event, context);
  alexa.registerHandlers(handlers);
  alexa.execute();
};

var handlers = {
  'LaunchRequest': function () {
    var me = this;
    request({
      method: 'POST',
      uri: '',
      },
      function (err, response, body) {
        if (err != null && err.code === 'ECONNRESET') {
          console.log(err);
          me.emit(':tell', 'Opening!');
        }
    });
  }
};
