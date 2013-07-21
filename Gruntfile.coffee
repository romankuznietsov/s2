mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    regarde:
      jade:
        files: 'client/templates/*.jade'
        tasks: ['jade']
      coffee:
        files: 'client/scripts/*.coffee'
        tasks: ['coffee:client']
      stylus:
        files: 'client/stylesheets/*.styl'
        tasks: ['stylus']

    jade:
      compile:
        options:
          pretty: true
        files: [{
          expand: true
          cwd: 'client/templates'
          src: '*.jade'
          dest: '.tmp'
          ext: '.html'
        }]

    coffee:
      compile:
        files: [{
          expand: true
          cwd: 'client/scripts'
          src: '*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        }]

    stylus:
      compile:
        files: [{
          expand: true
          cwd: 'client/stylesheets'
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
    {Server} = require './server/server'
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
