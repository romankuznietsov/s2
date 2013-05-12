mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    regarde:
      jade:
        files: 'app/templates/*.jade'
        tasks: ['jade']
      coffee:
        files: ['app/scripts/client/*']
        tasks: ['coffee']
    jade:
      compile:
        options:
          pretty: true
        files:
          '.tmp/index.html': ['app/templates/index.jade']
    coffee:
      compile:
        files: [{
          expand: true
          cwd: 'app/scripts/client'
          src: '*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        }]
    connect:
      options:
        port: 3000
        hostname: 'localhost'
      dev:
        options:
          middleware: (connect) ->
            return [
              mountFolder(connect, '.tmp'),
              mountFolder(connect, 'public')
            ]

  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'jade',
      'coffee',
      'connect:dev',
      'regarde'
    ]
