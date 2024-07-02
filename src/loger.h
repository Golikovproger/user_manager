#ifndef LOGGER_H
#define LOGGER_H

#include <QObject>
#include <QSql>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QDebug>
#include <QFile>
#include <QCoreApplication>

class Logger : public QObject {
  Q_OBJECT

      public:
               explicit Logger(QObject *parent = nullptr);
  ~Logger();

  bool initializeDatabase();
  void logAction(const QString &message);
  bool exportToCSV(const QString &filePath);

private:
  const QString LOG_DIR = "/var/log/user_manager";
  QSqlDatabase db;
  bool createTable();
};

#endif // LOGGER_H
