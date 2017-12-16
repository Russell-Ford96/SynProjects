var dbGet = angular.module('dbGet', []);

dbGet.controller("dbGetter", function($scope, $http) {
  
  $scope.products = function() {
    $http.get("/apexproducts").success(function(names){
      $scope.names = apexproducts.list;
    });
  };
});
  