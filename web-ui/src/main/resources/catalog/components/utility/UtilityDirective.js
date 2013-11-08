(function() {
  goog.provide('gn_utility_directive');

  angular.module('gn_utility_directive', [
  ])
  .directive('groupsCombo', ['$http',
        function($http) {
          return {
            restrict: 'A',
            templateUrl: '../../catalog/templates/utils/groupsCombo.html',
            controller: ['$scope', '$translate', function($scope, $translate) {
              $http.get('admin.group.list@json').success(function(data) {
                $scope.groups = data !== 'null' ? data : null;
              });
            }]
          };
        }]);
})();
