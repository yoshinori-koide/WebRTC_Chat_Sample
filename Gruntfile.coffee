
module.exports = (grunt) ->
	pkg = grunt.file.readJSON 'package.json'
	webpackConfig = require "./webpack.config.js"
	grunt.initConfig
		clean:
			files: ['js']
		watch:
			files: ['src/**/*.coffee', 'src/**/*.litcoffee','!src/**/__tests__/*.*',]
			tasks: ['webpack']
		webpack:
			options:
				webpackConfig
			build :
				{}
	for t of pkg.devDependencies
		if t.substring(0, 6) is 'grunt-'
			grunt.loadNpmTasks t
	grunt.registerTask 'default', ['webpack:build', 'watch']
