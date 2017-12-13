 // app/routes.js

var path = require("path");

module.exports = function(app) {

// server routes ===========================================================

  var MongoClient = require('mongodb').MongoClient;
  var url = "mongodb://localhost:27017";

  MongoClient.connect(url, function(err, client) {
    if (err) throw err;
    else console.log('MongoDB initialized on port 27017')	
    var db = client.db('apex')

    db.listCollections().toArray(function(err, collInfos) {
      if (err) throw err;
      console.log("Displaying Test Query Collection: ");
        console.log(collInfos);
      });
  });

        // route to handle creating goes here (app.post)
        // route to handle delete goes here (app.delete)

        // frontend routes =========================================================
        // route to handle all angular requests
        app.get('*', function(req, res) {
            res.sendFile(path.join(__dirname, '../public/views', 'index.html'));  //('./public/views/index.html'); // load our public/index.html file
        });

    };