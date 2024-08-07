#include "users.h"
#include <QProcess>

UsersManager::UsersManager(QObject *parent) : QObject(parent) {
  QObject::connect(this, &UsersManager::updateUserList, this,
                   &UsersManager::getUsersList);
  QObject::connect(this, &UsersManager::updateGroupList, this,
                   &UsersManager::getGroupsList);
}

QStringList UsersManager::getUsersList() {
  QString awkScript = "awk -F: '{ \
        if ($3 == 0) { \
            role = \"Administrator (root)\" \
        } else if ($3 >= 1000) { \
            role = \"Regular User\" \
        } else { \
            role = \"Unknown\" \
        } \
        if (role != \"Unknown\" && role != \"System/Service Account\" && $1 != \"root\" && $1 != \"nobody\") { \
            printf \" %s\\n\", $1 \
        } \
    }' /etc/passwd";
  return executeCommand(awkScript);
}

bool UsersManager::sudoRules(const QString &password) {
  QProcess process;

  QStringList sudoArguments = {"-S", "ls"};

  process.start("sudo", sudoArguments);
  process.write(password.toUtf8() + "\n");
  process.closeWriteChannel();
  if (!process.waitForStarted()) {
    qDebug() << "Error starting sudo process:" << process.errorString();
    return false;
  }
  process.waitForFinished();
  int exitCode = process.exitCode();
  if (exitCode == 0) {
    return true;
  } else {
    return false;
  }
}

QStringList UsersManager::getGroupsList() {
  QString getGroupsScript = "awk -F: '{ printf \"%s\\n\", $1}' /etc/group";
  return executeCommand(getGroupsScript);
}

bool UsersManager::addUser(const QString &username, const QString &password) {
  QProcess process;

  QString command = QString("sudo -S useradd -m -s /bin/bash %1").arg(username);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  QByteArray sudoPassword = (password).toUtf8();
  process.write(sudoPassword);
  process.waitForBytesWritten();

  process.closeWriteChannel();

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message = "Пользователь " + username + " успешно добавлен.";
    log.logAction(message);
    emit updateUserList();
    return true;
  } else {
    QString message = "Не удалось добавить пользователя. Ошибка: " +
                      process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::deleteUser(const QString &username) {
  QProcess process;

  if (username == qgetenv("USER")) {
    QString message = "Нельзя удалить текущего пользователя.";
    log.logAction(message);
    return false;
  }

  QString command = QString("sudo -S userdel -r %1").arg(username);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message = "Пользователь " + username + " успешно удалён.";
    log.logAction(message);
    emit updateUserList();
    return true;
  } else {
    QString message = "Не удалось удалить пользователя. Ошибка: " +
                      process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::addGroup(const QString &groupname) {

  QProcess process;

  QString command = QString("sudo -S groupadd %1").arg(groupname);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message = "Группа " + groupname + " успешно добавлена.";
    log.logAction(message);
    emit updateGroupList();
    return true;
  } else {
    QString message =
        "Не удалось добавить группу. Ошибка: " + process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::deleteGroup(const QString &groupname) {
  QProcess process;

  QString command = QString("sudo -S groupdel %1").arg(groupname);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message = "Группа " + groupname + " успешно удалена.";
    log.logAction(message);
    emit updateGroupList();
    return true;
  } else {
    QString message =
        "Не удалось удалить группу. Ошибка: " + process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::addUserToGroup(const QString &username,
                                  const QString &groupname) {
  QProcess process;

  QString command =
      QString("sudo -S usermod -a -G %1 %2").arg(groupname, username);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message =
        "Пользователь " + username + " успешно добавлен в группы " + groupname;
    log.logAction(message);
    //    emit updateUserGroupList();
    return true;
  } else {
    QString message = "Не удалось добавить пользователя в группу. Ошибка: " +
                      process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::removeUserFromGroup(const QString &username,
                                       const QString &groupname) {
  QProcess process;

  QString command =
      QString("sudo -S gpasswd -d %1 %2").arg(username, groupname);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message =
        "Пользователь " + username + " успешно удален из группы " + groupname;
    log.logAction(message);
    //    emit updateUserGroupList();
    return true;
  } else {
    QString message = "Не удалось удалить пользователя из группу. Ошибка: " +
                      process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::createUserHome(const QString &username) {

  QProcess process;

  QString command = QString("sudo -S mkhomedir_helper %1").arg(username);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message =
        "Домашний каталог для пользователя " + username + " успешно создан.";
    log.logAction(message);
    return true;
  } else {
    QString message = "Не удалось создать домашний каталог. Ошибка: " +
                      process.readAllStandardError();
    log.logAction(message);
    return false;
  }
}

bool UsersManager::changeUserPassword(const QString &username,
                                      const QString &newPassword) {
  QProcess process;

  QString command = QString("sudo -S passwd %1").arg(username);

  process.start(command);

  if (!process.waitForStarted()) {
    QString message = "Не удалось запустить процесс.";
    log.logAction(message);
    return false;
  }

  QByteArray passwordInput = (newPassword + "\n" + newPassword + "\n").toUtf8();
  process.write(passwordInput);
  process.waitForBytesWritten();

  process.closeWriteChannel();

  if (!process.waitForFinished(-1)) {
    QString message = "Процесс не завершился вовремя.";
    log.logAction(message);
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    QString message =
        "Пароль для пользователя " + username + " успешно изменен.";
    log.logAction(message);
    return true;
  } else {
    qDebug() << "Не удалось изменить пароль. Ошибка:"
             << process.readAllStandardError();
    return false;
  }
}

QStringList UsersManager::getUsersInGroup(const QString &groupName) {

  QString awkScript =
      QString("getent group %1 | awk -F: '{print $4}'").arg(groupName);
  QStringList usersInGroup =
      executeCommand(awkScript).join("").split(",", Qt::SkipEmptyParts);

  QStringList filteredUsers;
  foreach (const QString &user, usersInGroup) {
    QString userInfoScript = QString("getent passwd %1 | awk -F: '{ \
            if ($3 == 0) { \
                role = \"Administrator (root)\" \
            } else if ($3 >= 1000) { \
                role = \"Regular User\" \
            } else { \
                role = \"Unknown\" \
            } \
            if (role != \"Unknown\" && role != \"System/Service Account\" && $1 != \"root\" && $1 != \"nobody\") { \
                printf \" %s\\n\", $1 \
            } \
        }'")
                                 .arg(user);
    QStringList userDetails = executeCommand(userInfoScript);
    if (!userDetails.isEmpty()) {
      filteredUsers << userDetails.first();
    }
  }

  return filteredUsers;
}

QStringList UsersManager::executeCommand(const QString &command) {
  QProcess process;
  process.start("/bin/sh", QStringList() << "-c" << command);
  process.waitForFinished();

  QByteArray output = process.readAllStandardOutput();
  QString outputStr(output);
  QStringList outputList = outputStr.split("\n", Qt::SkipEmptyParts);

  return outputList;
}
