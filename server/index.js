var express = require('express');
var memjs = require('memjs')

var app = express();

var mc = memjs.Client.create(process.env.MEMCACHIER_SERVERS, {
    failover: true,  // default: false
    timeout: 1,      // default: 0.5 (seconds)
    keepAlive: true  // default: false
  });


app.get("/", function(req, res) {
    const beat = parseInt(req.query.beat);
    if (beat !== null && beat !== undefined && beat > 0) {
        mc.set('beat', beat.toString(), {expires:0}, function(err, val) {
            if(err != null) {
              console.log('Error setting value: ' + err);
              res.sendStatus(500);
            }
            res.sendStatus(200);
          });

    } else {
        
          mc.get('beat', function(err, val) {
            if(err != null) {
              console.log('Error getting value: ' + err)
              res.json({'beat': 0})
            } else {
                res.json({'beat': val.toString('utf8')});
            }
          });
    }
});

// Initialize the app.
var server = app.listen(process.env.PORT || 8080, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
  });