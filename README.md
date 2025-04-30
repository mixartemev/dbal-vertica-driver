DBAL Vertica driver
===================

Doctrine DBAL connector driver for Vertica.
*Ready for use in **Laravel** / Lumen*

Requirements
------------
* php >= 7.4
* php_odbc extension
* Vertica drivers
* Doctrine >=2 DBAL

Installation
------------
*Case for Ubuntu / Debian*
##### Vertica drivers:

```shell
# Download official Vertica ODBC driver
curl -OL https://www.vertica.com/client_drivers/12.0.x/12.0.4-0/vertica-client-12.0.4-0.x86_64.tar.gz

# Extract & install it
sudo tar -xvzf vertica-client-12.0.4-0.x86_64.tar.gz -C /

# Set config files
sudo printf "[VerticaDev]\nDriver = /opt/vertica/lib64/libverticaodbc.so\nPort = 5433\nDriver = Vertica" > /etc/odbc.ini
sudo printf "[Vertica]\nDriver = /opt/vertica/lib64/libverticaodbc.so" > /etc/odbcinst.ini
sudo printf "[Driver]\nDriverManagerEncoding=UTF-16\nODBCInstLib = /usr/lib/x86_64-linux-gnu/libodbcinst.so.1\nErrorMessagesPath=/opt/vertica/lib64\nLogLevel=4\nLogPath=/tmp" > /etc/vertica.ini
```

##### PHP extentions & ODBC unix client:
```bash
sudo apt-get install php-odbc php-pdo php-json unixodbcn
```

##### PDO Connector compatible with Doctrine 2 DBAL:
```bash
composer require mixartemev/dbal-vertica-driver
```

Integration in Laravel
----------------------

##### .env
```
DB_HOST_VERTICA=127.0.0.1
#DB_PORT_VERTICA=5433 (DONT SET PORT! IT MUST BE EXACTLY INTEGER! GETTING FROM dafaults in )
DB_DATABASE_VERTICA=dbname
DB_USERNAME_VERTICA=username
DB_PASSWORD_VERTICA=password
```

##### config/database.php
```php
<?php
return [
    'connections' => [
        'vertica' => [
            'driver' => 'vertica',
            'host' => env('DB_HOST_VERTICA', '127.0.0.1'),
            'port' => env('DB_PORT_VERTICA', 5433), //EXACTLY DIGITS, NOT STRING
            'database' => env('DB_DATABASE_VERTICA', 'forge'),
            'username' => env('DB_USERNAME_VERTICA', 'forge'),
            'password' => env('DB_PASSWORD_VERTICA', ''),
            'schema' => 'public',
            'sslmode' => 'allow',
            'options' => [
                PDO::ATTR_EMULATE_PREPARES => false,
            ]
        ]
    ];
```

##### app/Providers/AppServiceProvider.php
```php
<?php
class AppServiceProvider extends ServiceProvider
{
    public function boot()
    {
        App::bind('db.connector.vertica', function () {
            return new VerticaDriver;
        });
        DB::resolverFor('vertica', function ($connection, $database, $prefix, $config) {
            return new PostgresConnection($connection, $database, $prefix, $config);
        });
    }
}
```

### Docker
Demo installing on Linux Alpine:
```
docker build . -t vert
docker run vert
```
