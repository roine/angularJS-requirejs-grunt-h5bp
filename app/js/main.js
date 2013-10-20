require.config({
	paths: {
		angular: '../../bower_components/angular/angular',
		angularRoute: '../../bower_components/angular-route/angular-route',
		angularMocks: '../../bower_components/angular-mocks/angular-mocks',
		text: '../../bower_components/requirejs-text/text'
	},
	baseUrl: 'app/js',
	shim: {
		'angular' : {'exports' : 'angular'},
		'angularRoute': ['angular'],
		'angularMocks': {
			deps:['angular'],
			'exports':'angular.mock'
		}
	},
	priority: [
		"angular"
	]
});


// hey Angular, we're bootstrapping manually!
window.name = "NG_DEFER_BOOTSTRAP!";


// Avoid `console` errors in browsers that lack a console.
var method;
var noop = function () {};
var methods = [
    'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
    'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
    'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
    'timeStamp', 'trace', 'warn'
];
var len = methods.length;
var console = (window.console = window.console || {});

while (len--) {
    method = methods[len];

    // Only stub undefined methods.
    if (!console[method]) {
        console[method] = noop;
    }
}

require( [
	'angular',
	'app',
	'routes'
], function(angular, app, routes) {
	'use strict';
	var $html = angular.element(document.getElementsByTagName('html')[0]);

	angular.element().ready(function() {
		$html.addClass('ng-app');
		angular.bootstrap($html, [app.name]);
	});
});
