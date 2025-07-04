SHOW DATABASES;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '@root';
FLUSH PRIVILEGES;

CREATE USER 'powerbi'@'localhost' IDENTIFIED WITH mysql_native_password BY 'pbiuser';
GRANT ALL PRIVILEGES ON *.* TO 'powerbi_user'@'localhost';
FLUSH PRIVILEGES;

SELECT User, Host FROM mysql.user;
CREATE USER 'powerbi'@'localhost' IDENTIFIED WITH mysql_native_password BY 'pbipassword';
GRANT ALL PRIVILEGES ON awesome_chocolates_data.* TO 'powerbi'@'localhost';
FLUSH PRIVILEGES;
