var dbGet = angular.module('dbGet', []);

dbGet.controller("dbGetter", function($scope, $http) {
    console.log("controller loaded");
  
  $scope.products = function() {
      $http.get("/apexproducts")
          .then(function(names){
                console.log(names);
                $scope.names = names;
        }, function(err) {
                console.log(err);
        });
  };

    $scope.products();
});
  
