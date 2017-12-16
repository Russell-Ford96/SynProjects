 // app/routes.js

var path = require("path");

module.exports = function(app) {

// server routes ===========================================================

var MongoClient = require('mongodb').MongoClient;
var url = "mongodb://localhost:27017/apex";

app.get("/apexproducts", function(request, response){
  
  MongoClient.connect(url, function(err, client) {
    var result = {};
    if (err) throw err;
    else {
      console.log('MongoDB initialized on port 27017');
      var collection = database.collection("apexproducts");
      collection.find().toArray((err, products)=>{
        response.send({"list":products});
      });
    }
  });
});

  
        // frontend routes =========================================================
        // route to handle all angular requests
        app.get('*', function(req, res) {
            res.sendFile(path.join(__dirname, '../public/views', 'index.html'));  //('./public/views/index.html'); // load our public/index.html file
        });

    };