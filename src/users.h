#ifndef USERSMANAGER_H
#define USERSMANAGER_H

#include <QObject>
#include <QStringList>
#include <QDebug>
#include "loger.h"

class UsersManager : public QObject
{
  Q_OBJECT
      public:
               explicit UsersManager(QObject *parent = nullptr);

     // Добавление пользователя
  Q_INVOKABLE bool addUser(const QString &username, const QString &password);

     // Удаление пользователя
  Q_INVOKABLE bool deleteUser(const QString &username);

     // Добавление группы
  Q_INVOKABLE bool addGroup(const QString &groupname);

     // Удаление группы
  Q_INVOKABLE bool deleteGroup(const QString &groupname);

     // Добавление пользователя в группу
  Q_INVOKABLE bool addUserToGroup(const QString &username, const QString &groupname);

     // Удаление пользователя из группы
  Q_INVOKABLE bool removeUserFromGroup(const QString &username, const QString &groupname);

     // Создание домашнего каталога пользователя
  Q_INVOKABLE bool createUserHome(const QString &username);

     // Редактирование пароля пользователя
  Q_INVOKABLE bool changeUserPassword(const QString &username, const QString &newPassword);

  Q_INVOKABLE bool sudoRules(const QString &password);

    // Получение имени текущего пользователя
  Q_INVOKABLE QString getUserName() { return qgetenv("USER"); };

public slots:
      // Получение списка пользователей
  Q_INVOKABLE QStringList getUsersList();

     // Получение списка групп
  Q_INVOKABLE QStringList getGroupsList();

     // Получение списка пользователей в группе
  Q_INVOKABLE QStringList getUsersInGroup(const QString &groupName);

private:
  QStringList executeCommand(const QString &command);
  Logger log;


signals:
    // Сигнал на обновление списка пользователей
  void updateUserList();

    // Сигнал на обновление списка групп
  void updateGroupList();
};

#endif // USERSMANAGER_H
