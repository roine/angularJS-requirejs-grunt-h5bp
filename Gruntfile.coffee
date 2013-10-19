module.exports = (grunt) ->
	grunt.initConfig {
		pkg: grunt.file.readJSON('package.json'),
		js_files: ['app/**/*.js', 'test/**/*js', '!app/dist/**/*.js'],
		css_files: ['app/**/*.css', '!app/dist/**/*.css'],
		sass_files: ['app/**/.scss'],
		jshint: {
			files: ['<%= js_files %>'],
			options: {
				jshintrc:'.jshintrc'
			}
		},
		compass: {	
			config: 'config.rb',
			dev: {
				options: {
					environment: 'development'
				}
			}
			dist: {
				options: {
					environment: 'production'
					cssDir: 'app/dist/css'
				}	
			}
		},
		connect: {
			server: {
				options: {
				port: 8000,
				keepalive: true,
				open: true,
				livereload: true
				}
			}
		},
		watch: {
			scss: {
				files: ['<%= sass_files %>'],
				tasks: ['compass:dev']
			}
			css: {
				files: ['<%= css_files %>'],
				options: {
					livereload: true,
					spawn: false
				}
			}
			js: {
				files: ['<%= js_files %>'],
				tasks: ['jshint'],
				options: {
					livereload:true
				}
			}
		},
		requirejs: {
			compile: {
				options: {
					baseUrl: 'app/js',
					paths: {
						angular: '../../bower_components/angular/angular',
						angularRoute: '../../bower_components/angular-route/angular-route',
						angularMocks: '../../bower_components/angular-mocks/angular-mocks',
						text: '../../bower_components/requirejs-text/text'
					},
					shim: {
						'angular' : {'exports' : 'angular'},
						'angularRoute': ['angular'],
						'angularMocks': {
							deps:['angular'],
							'exports':'angular.mock'
						}
					},
					out: 'app/dist/js/main.built.js',
					name:'main',
					preserveLicenseComments: false,
				}
			}
		},
		karma: {
			unit: {
				configFile: 'config/karma.conf.js'
			},
			e2e: {
				configFile: 'config/karma-e2e.conf.js'
			}
		},
		concurrent: {
			server: ['watch', 'connect'],
			options: {
				logConcurrentOutput: true
			}
		},
		targethtml: {
			dist: {
				files: {
					'index.html': 'index.pre.html'
				}
			}
			dev: {
				files: {
					'index.html': 'index.pre.html'
				},
				options: {
					curlyTags: {
			        	rlsdate: '<%= grunt.template.today("yyyymmdd") %>'
				    }	
				}	
			}
		}
	}
	npmTasks = [
		'grunt-contrib-jshint',
		'grunt-contrib-compass',
		'grunt-contrib-connect',
		'grunt-contrib-watch',
		'grunt-contrib-requirejs',
		'grunt-karma',
		'grunt-concurrent',
		'grunt-targethtml'
	]
	grunt.loadNpmTasks(task) for task in npmTasks

	grunt.registerTask 'lint', ['jshint']
	grunt.registerTask 'build', ['jshint', 'compass:dist', 'requirejs', 'targethtml:dist']
	grunt.registerTask 'test', ['karma']
	grunt.registerTask 'server', 'launch the server', (n) ->
		if grunt.option('dist')
			grunt.task.run ['build', 'concurrent:server']
		else 
			grunt.task.run ['targethtml:dev', 'concurrent:server']