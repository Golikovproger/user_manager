# user_manager

## Настройка логирования
Для корректной работы логирования в приложении требуется предустановленный PostgreSQL. Необходимо настроить параметры подключения к базе данных в функции `initializeDatabase()` в классе `Logger` в соответствии с вашей конфигурацией PostgreSQL. Ниже приведен пример настройки:

```
db.setHostName("localhost"); // Укажите хост вашей базы данных
db.setDatabaseName("loggerdb"); // Укажите имя вашей базы данных
db.setUserName("postgres"); // Укажите имя пользователя PostgreSQL
db.setPort(5432); // Укажите порт, используемый PostgreSQL
db.setPassword("1234"); // Укажите пароль пользователя PostgreSQL
```

## Инструкция по запуску
В корневой директории проекта выполнить следующие команды:
1. `mkdir build`
2. `cd build`
3. `cmake ..`
4. `make`
5. `cpack`
6. `./user_manager`
