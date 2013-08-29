module.exports = (grunt) ->
  grunt.initConfig
    bowerDirectory: require('bower').config.directory
    less:
      compile:
        options:
          compress: false
          paths: ['less', 'tmp', '<%= bowerDirectory %>/bootstrap/less']
        files:
          'dist/css/bootstrap.css': ['less/theme.less']
    recess:
      dist:
        options:
          compile: true
        files:
          'dist/css/bootstrap.css': ['dist/css/bootstrap.css']
    watch:
      less:
        files: ['less/*.less']
        tasks: ['copy', 'less:compile', 'clean']
        options:
          livereload: true
      cssmin:
        files: ['dist/css/bootstrap.css']
        tasks: ['cssmin:minify']
    cssmin:
      minify:
        expand: true
        cwd: 'dist/css'
        src: ['*.css', '!*.min.css']
        dest: 'dist/css'
        ext: '.min.css'
    connect:
      serve:
        options:
          port: grunt.option('port') || '8000'
          hostname: grunt.option('host') || 'localhost'
    assemble:
      pages:
        options:
          data: './bower.json',
          flatten: true,
          assets: 'dist'
        files:
          'index.html': ['pages/index.html'],
          'examples/': ['pages/examples/*.html']
    copy:
      bootstrap:
        files: [
          { expand: true, cwd: '<%= bowerDirectory %>/bootstrap/less', src: ['bootstrap.less'], dest: 'tmp/' },
          { expand: true, cwd: '<%= bowerDirectory %>/font-awesome/font', src: ['*'], dest: 'dist/fonts' }
        ]
    clean: ['tmp']
    inlinecss:
            main:
                options: {
                },
                files: {
                    './examples/weimarnetz-captive-inline.html': './examples/weimarnetz-captive.html',
                }

  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-recess')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-text-replace')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-inline-content');
  grunt.loadNpmTasks('assemble')

  grunt.registerTask('default', ['copy', 'less', 'recess', 'cssmin', 'inlinecss', 'assemble', 'clean'])
  grunt.registerTask('serve', ['connect', 'watch'])
