# Use a Postfix container

It's always nice to have a Postfix somewhere for sending `no-reply` e-mails!

By chance, there is a cool docker image which will help us with that: https://github.com/catatnight/docker-postfix

First, update your `docker-compose.yml.template` file with the following:

```
postfix:
  image: catatnight/postfix:latest
  restart: unless-stopped
  container_name: {PROJECT_NAME}_postfix_{ENV}
  ports:
    - 25:25
  environment:
    maildomain: {ENV_DOMAIN_NAME}
    smtp_user: no-reply@{ENV_DOMAIN_NAME}:admin
  networks:
    - {ENV}
```

Then just run `make kickoff`! You have now at your disposal a nice Postfix container :smiley:

**Note:** if you want to test the quality of the e-mails send by your Postfix container, we recommend using this nice tool: https://www.mail-tester.com/.