FROM nginx:1.12-alpine

# |--------------------------------------------------------------------------
# | Permissions issues workaround
# |--------------------------------------------------------------------------
# |
# | On Linux, the UID arg will be set with the UID of the current user
# | from the host.
# |

ARG UID=1000
RUN adduser -D -u $UID www-data &&\
    rm /etc/nginx/conf.d/default.conf