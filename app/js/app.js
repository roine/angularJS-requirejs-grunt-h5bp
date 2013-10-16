define([
	'angular',
	'filters',
	'services',
	'directives',
	'controllers',
	'angularRoute',
	], function (angular, filters, services, directives, controllers) {
		'use strict';

		return angular.module('brume', [
			'ngRoute',
			'brume.controllers',
			'brume.filters',
			'brume.services',
			'brume.directives'
		]);
});
