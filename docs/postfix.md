# Install a Postfix container

It's always nice to have a Postfix somewhere for sending `no-reply` e-mails!

By chance, there is a cool docker image which will help us with that: https://github.com/catatnight/docker-postfix

First, update your `.env.template` file by adding:

```
# postfix
POSTFIX_SERVICE_NAME=postfix
POSTFIX_CONTAINER=${PROJECT_NAME}_${POSTFIX_SERVICE_NAME}_${ENV}
MAIL_DOMAIN=${APACHE_VIRTUAL_HOST}
NO_REPLY_EMAIL=no-reply@dev.yourproject.com
SMTP_PASSWORD=admin
```

Then, update your `docker-compose.yml.template` file with the following:

```
${POSTFIX_SERVICE_NAME}:
  image: catatnight/postfix:latest
  restart: unless-stopped
  container_name: ${POSTFIX_CONTAINER}
  ports:
    - 25:25
  environment:
    maildomain: ${MAIL_DOMAIN}
    smtp_user: ${NO_REPLY_EMAIL}:${SMTP_PASSWORD}
  networks:
    - scope_${ENV}
```

Add the following lines in the `prepare()` method of the `_prepare` script (in `bin` directory):

```
# postfix
sedi "s/\${POSTFIX_SERVICE_NAME}/${POSTFIX_SERVICE_NAME}/g" ${ROOT}/docker-compose.yml;
sedi "s/\${POSTFIX_CONTAINER}/${POSTFIX_CONTAINER}/g" ${ROOT}/docker-compose.yml;
sedi "s/\${MAIL_DOMAIN}/${MAIL_DOMAIN}/g" ${ROOT}/docker-compose.yml;
sedi "s/\${NO_REPLY_EMAIL}/${NO_REPLY_EMAIL}/g" ${ROOT}/docker-compose.yml;
sedi "s/\${SMTP_PASSWORD}/${SMTP_PASSWORD}/g" ${ROOT}/docker-compose.yml;
```

Last but not least, run `cp .env.template .env` and `make kickoff`! You have now at your disposal a nice Postfix container :smiley:

**Note:** if you want to test the quality of the e-mails send by your Postfix container, we recommend using this nice tool: https://www.mail-tester.com/.
