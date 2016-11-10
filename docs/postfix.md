# Install a Postfix container

It's always nice to have a Postfix somewhere for sending `no-reply` e-mails!

By chance, there is a cool docker image which will help us with that: https://github.com/catatnight/docker-postfix

First, remove the `docker-compose.yml` file and update your `docker-compose.yml.template` file with the following:

```
postfix:
  image: catatnight/postfix:latest
  restart: unless-stopped
  container_name: _postfix_
  ports:
    - 25:25
  environment:
    maildomain:
    smtp_user: :admin
  networks:
    - scope_
```

Then add the following lines in the `prepare()` method of the `_prepare` script (in `bin` directory):

```
sedi "s/container_name: .*_postfix_.*/container_name: ${PROJECT_NAME}_postfix_${ENV}/g" ${ROOT}/docker-compose.yml;
sedi "s/maildomain: .*/maildomain: $ENV_DOMAIN_NAME/g" ${ROOT}/docker-compose.yml;
sedi "s/smtp_user: .*:/smtp_user: no-reply@$ENV_DOMAIN_NAME:/g" ${ROOT}/docker-compose.yml;
```

Last but not least, run `make kickoff`! You have now at your disposal a nice Postfix container :smiley:

**Note:** if you want to test the quality of the e-mails send by your Postfix container, we recommend using this nice tool: https://www.mail-tester.com/.