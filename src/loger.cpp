#include "loger.h"

Logger::Logger(QObject *parent) : QObject(parent) {
  if (!initializeDatabase()) {
    qDebug() << "Ошибка инициализации базы данных.";
  }
}

Logger::~Logger() {
  if (db.isOpen()) {
    db.close();
  }
}

bool Logger::initializeDatabase() {
  db = QSqlDatabase::addDatabase("QPSQL");
  db.setHostName("localhost");
  db.setDatabaseName("logerdb");
  db.setUserName("postgres");
  db.setPort(5432);
  db.setPassword("1234");

  if (!db.open()) {
    qDebug() << "Ошибка: Невозможно подключитья к базе данных."
             << db.lastError().text();
    return false;
  }
  return createTable();
}

bool Logger::createTable() {
  QSqlQuery query;
  QString createTableSQL = R"(
        CREATE TABLE IF NOT EXISTS logger_table (
            id SERIAL PRIMARY KEY,
            datetime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            message VARCHAR(255) NOT NULL
        );
    )";

  if (!query.exec(createTableSQL)) {
    qDebug() << "Ошибка: Невозможно создать таблицу:"
             << query.lastError().text();
    return false;
  }

  return true;
}

void Logger::logAction(const QString &message) {
  QSqlQuery query;
  query.prepare(
      "INSERT INTO logger_table (message, datetime) VALUES (:message, NOW())");
  query.bindValue(":message", message);

  if (!query.exec()) {
    qDebug() << "Ошибка: Невозможно вставить запись журнала:"
             << query.lastError().text();
  }
}

bool Logger::exportToCSV(const QString &fileName) {
  QString filePath = QCoreApplication::applicationDirPath() + "/" + fileName;
  QFile file(filePath);
  if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
    qDebug() << "Ошибка: Невозможно открыть файл для записи.";
    return false;
  }

  QTextStream out(&file);
  QSqlQuery query("SELECT id, datetime, message FROM logger_table");

  out << "id,datetime,message\n";

  while (query.next()) {
    int id = query.value(0).toInt();
    QString datetime = query.value(1).toString();
    QString message = query.value(2).toString();

    out << id << "," << datetime << "," << message << "\n";
  }

  file.close();
  return true;
}
