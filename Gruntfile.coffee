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
        files: 'app/scripts/client/*.coffee'
        tasks: ['coffee:client']
      stylus:
        files: 'app/stylesheets/*.styl'
        tasks: ['stylus']

    jade:
      compile:
        options:
          pretty: true
        files: [{
          expand: true
          cwd: 'app/templates'
          src: '*.jade'
          dest: '.tmp'
          ext: '.html'
        }]

    coffee:
      compile:
        files: [{
          expand: true
          cwd: 'app/scripts/client'
          src: '*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        }]

    stylus:
      compile:
        files: [{
          expand: true
          cwd: 'app/stylesheets'
          src: '*.styl'
          dest: '.tmp/stylesheets'
          ext: '.css'
        }]


    connect:
      options:
        port: 3000
        hostname: '0.0.0.0'
      dev:
        options:
          middleware: (connect) ->
            return [
              mountFolder(connect, '.tmp'),
              mountFolder(connect, 'public')
              mountFolder(connect, 'components')
            ]

    clean: ['.tmp']

  grunt.registerTask 'websocket-server', (target) ->
    {Server} = require './app/scripts/server'
    server = new Server(3001)

  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'clean',
      'jade',
      'coffee',
      'stylus',
      'connect:dev',
      'websocket-server',
      'regarde'
    ]
