module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    pkg: pkg
    path:
      src: 'src'
      dist: 'dist'

    coffee:
      dist:
        expand: true
        cwd: '<%= path.src %>'
        src: '**/*.coffee'
        dest: '<%= path.dist %>'
        ext: '.js'
    ngmin:
      dist:
        expand: true
        cwd: '<%= path.dist %>'
        src: '**/*.js'
        dest: '<%= path.dist %>'

    watch:
      coffee:
        files: ['<%= path.src %>/**/*.coffee']
        tasks: ['build', 'karma:unit:run']
      karma:
        files: ['test/**/*.spec.coffee']
        tasks: ['karma:unit:run']

    karma:
      unit:
        configFile: 'test/karma.conf.js'
        background: true
        browsers: ['PhantomJS']
      unitSingle:
        configFile: 'test/karma.conf.js'
        singleRun: true

    bump:
      options:
        files: ['bower.json', 'package.json']
        commitFiles: ['bower.json', 'package.json']
        pushTo: 'origin'

  # Load tasks from all required grunt plugins.
  for dep of pkg.devDependencies when dep.indexOf('grunt-') is 0
    grunt.loadNpmTasks(dep)

  grunt.registerTask('build', ['coffee', 'ngmin'])
  grunt.registerTask('test', ['build', 'karma:unitSingle'])
  grunt.registerTask('dev', ['build', 'karma:unit', 'watch'])
