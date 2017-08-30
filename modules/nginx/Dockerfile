FROM nginx:1.12-alpine

# |--------------------------------------------------------------------------
# | Permissions issues workaround
# |--------------------------------------------------------------------------
# |
# | On Linux and Mac, the UID arg will be set with the UID of the
# | current user from the host.
# |

# 82 is the standard uid/gid for "www-data" in Alpine
ARG UID=82

RUN addgroup -g 82 -S www-data &&\
    adduser -u $UID -D -S -G www-data www-data &&\
    rm /etc/nginx/conf.d/default.conf