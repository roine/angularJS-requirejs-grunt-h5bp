# Note, I don't use compass to minify to be able to use autoprefixer
# Note 2, dropped compass, too slow and useless since autoprefixer

module.exports = (grunt) ->

	require('time-grunt')(grunt);

	files = {
		js: ['app/**/*.js', 'test/**/*js', '!app/dist/**/*.js']
		css: ['app/**/*.css', '!app/dist/**/*.css']
		sass: ['app/**/*.scss']
		img: ['app/**/*.{png,jpg,gif}']
		html: ['app/**/*.html', 'index.html']
	}

	grunt.initConfig {
		pkg: grunt.file.readJSON('package.json'),
		files: files
		jshint: {
			files: ['<%= files.js %>']
			options: {
				jshintrc:'.jshintrc'
			}
		}
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
		sass: {
			dev: {
				options: {
					lineNumbers: true
					style: 'expanded'
				}
				files: {
					'app/css/app.css': 'app/sass/app.scss'
				}
			}
		}
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
				files: ['<%= files.sass %>'],
				tasks: ['sass:dev', 'autoprefixer:dev']
			}
			css: {
				files: ['<%= files.css %>']
				options: {
					livereload: true
					spawn: false
				}
			}
			js: {
				files: ['<%= files.js %>']
				tasks: ['jshint']
				options: {
					livereload:true
				}
			}
			html: {
				files: ['<%= files.html %>']
				options: {
					livereload: true
					spawn:false
				}
			}
			index: {
				files: ['index.pre.html']
				tasks: ['targethtml:dev']
			}
		},
		requirejs: {
			compile: {
				options: {
					baseUrl: 'app/js'
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
		},
		autoprefixer: {
			options: {
				# https://github.com/ai/autoprefixer#browsers
				browsers: ["last 1 version", "> 1%", "ie 8", "ie 7"]
			}
			dev: {
				src: 'app/css/app.css'
				dest: 'app/css/app.css'
			}
		},
		cssmin: {
			'app/dist/css/app.css': '<%= files.css %>'
		}
	}
	npmTasks = [
		'grunt-contrib-jshint'
		'grunt-contrib-compass'
		'grunt-contrib-connect'
		'grunt-contrib-watch'
		'grunt-contrib-requirejs'
		'grunt-karma'
		'grunt-concurrent'
		'grunt-targethtml'
		'grunt-autoprefixer'
		'grunt-contrib-cssmin'
		# migrated from grunt-contrib-sass because it's faster, but no line number option
		'grunt-sass'
	]
	grunt.loadNpmTasks(task) for task in npmTasks


	grunt.registerTask 'lint', ['jshint']
	grunt.registerTask 'build', ['autoprefixer:dev', 'cssmin', 'jshint', 'requirejs', 'targethtml:dist']
	grunt.registerTask 'test', ['karma']
	grunt.registerTask 'server', 'launch the server', (n) ->
		if grunt.option('dist')
			grunt.task.run ['build', 'concurrent:server']
		else
			grunt.task.run ['targethtml:dev', 'concurrent:server']
