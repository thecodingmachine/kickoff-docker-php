# Use MySQL Workbench to manage your database

First, update the MySQL service in your `docker-compose-ym` file by adding:

```
ports:
  - 3307:3306
```

Then, download the last version of MySQL Workbench following the official instructions: https://www.mysql.fr/products/workbench/

Run the application and click on the `+` button next to `MySQL Connections` to setup a new connection:

<img src="images/mysql_workbench1.png" alt="Setup a new connection" />

Once done, click on `Test Connection` to check if your setup is correct. If so, click on `Ok` to save your setup.