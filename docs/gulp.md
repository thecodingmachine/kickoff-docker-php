# Install Gulp

First, launch your environment with `make kickoff` and install gulp with `make npm cmd="install --save-dev gulp"`.

Then, create a `_gulp` file in the bin folder with this content:

```
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
ROOT=${DIR}/..;

# environment variables
source ${ROOT}/.env;

usage()
{
    echo "Usage:";
    echo "./_gulp --task your_task";
    exit 0;
}

missing_arg()
{
    echo "ERROR: Missing argument $1."
    exit 1;
}

gulp()
{
     /bin/bash ${DIR}/_health_check --container_name ${APACHE_CONTAINER_NAME};

    if [ $? -eq 1 ]; then
        /bin/bash ${DIR}/_whalesay --say "Apache container (${APACHE_CONTAINER_NAME}) is not running.";
        exit 1;
    fi;

    docker exec -ti ${APACHE_CONTAINER_NAME} /var/www/html/node_modules/.bin/gulp ${CMD};
}

# checking parameters
if [ "$#" -eq 0 ]; then
    usage;
    exit 1;
fi;

while [ "$1" != "" ]; do
    case $1 in
        --task ) shift
            if [ -z "$1" ]; then
                missing_arg --task;
            fi;
            CMD=$1 ;;
    esac
    shift
done;

gulp;

exit 0;
```

Run `chmod a+x _gulp` to avoid permission issue.

Then, update the `Makefile` by adding:

```
gulp:
	./bin/_gulp --task $(cmd);
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
