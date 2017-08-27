FROM nginx:1.12-alpine

# |--------------------------------------------------------------------------
# | Permissions issues workaround
# |--------------------------------------------------------------------------
# |
# | On Linux, the UID ang GID args will be set with the UID and GID of the
# | current user from the host.
# |

# 82 is the standard uid/gid for "www-data" in Alpine
ARG UID=82
ARG GID=82

RUN addgroup -g $GID -S www-data &&\
    adduser -u $UID -D -S -G www-data www-data &&\
    rm /etc/nginx/conf.d/default.conf