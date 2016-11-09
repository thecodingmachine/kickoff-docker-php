# Use Gulp

First, launch your environment with `Make kickoff` and install gulp with `make npm cmd="install --save-dev gulp"`.

For convenience purpose, add this command in your `Makefile`:

```
gulp:
	docker exec --user="custom_user" -ti ${APACHE_CONTAINER} /var/www/html/node_modules/.bin/gulp $(cmd);
```

**Note:** make sure that your `Makefile` uses tab indents! In PhpStorm, click on `Edit > Convert Indents > To Tabs`.

Alright, now create a `gulpfile.js` in `apache/volume` containing:

```
var gulp = require('gulp');

gulp.task('default', function() {
  // place code for your default task here
});
```

You are now able to use gulp by running `make gulp cmd=yourtask`! :metal: