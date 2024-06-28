#include "users.h"
#include <QProcess>

UsersManager::UsersManager(QObject *parent) : QObject(parent) {
  QObject::connect(this, &UsersManager::updateUserList, this,
                   &UsersManager::getUsersList);
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
            printf \" %s %s\\n\", $1, role \
        } \
    }' /etc/passwd";
  return executeCommand(awkScript);
}

void UsersManager::sudoRules(const QString &password) {
  QProcess process;

  QStringList sudoArguments = {"-S", "ls"};

  process.start("sudo", sudoArguments);
  process.write(password.toUtf8() + "\n");
  process.closeWriteChannel();
  if (!process.waitForStarted()) {
    qDebug() << "Error starting sudo process:" << process.errorString();
    return;
  }
  //  while (process.waitForReadyRead()) {
  //    qDebug() << "Output:" << process.readAllStandardOutput();
  //  }
  //  while (process.waitForReadyRead()) {
  //    qDebug() << "Error Output:" << process.readAllStandardError();
  //  }
  process.waitForFinished();

  //  qDebug() << "Exit code:" << process.exitCode();
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
    qDebug() << "Не удалось запустить процесс.";
    return false;
  }

  QByteArray sudoPassword = (password).toUtf8();
  process.write(sudoPassword);
  process.waitForBytesWritten();

  process.closeWriteChannel();

  if (!process.waitForFinished(-1)) {
    qDebug() << "Процесс не завершился вовремя.";
    return false;
  }

  int exitCode = process.exitCode();
  if (exitCode == 0) {
    qDebug() << "Пользователь" << username << "успешно добавлен.";
    emit updateUserList();
    return true;
  } else {
    qDebug() << "Не удалось добавить пользователя. Ошибка:"
             << process.readAllStandardError();
    return false;
  }
}

bool UsersManager::deleteUser(const QString &username) {
  return QProcess::execute("sudo", QStringList() << "userdel" << username) == 0;
}

bool UsersManager::addGroup(const QString &groupname) {
  return QProcess::execute("sudo", QStringList() << "groupadd" << groupname) ==
         0;
}

bool UsersManager::deleteGroup(const QString &groupname) {
  return QProcess::execute("sudo", QStringList() << "groupdel" << groupname) ==
         0;
}

bool UsersManager::addUserToGroup(const QString &username,
                                  const QString &groupname) {
  return QProcess::execute("sudo", QStringList()
                                       << "usermod"
                                       << "-a"
                                       << "-G" << groupname << username) == 0;
}

bool UsersManager::removeUserFromGroup(const QString &username,
                                       const QString &groupname) {
  return QProcess::execute("sudo", QStringList()
                                       << "gpasswd"
                                       << "-d" << username << groupname) == 0;
}

bool UsersManager::createUserHome(const QString &username) {
  return QProcess::execute("sudo", QStringList() << "mkdir"
                                                 << "-p"
                                                 << "/home/" + username) == 0;
}

bool UsersManager::changeUserPassword(const QString &username,
                                      const QString &newPassword) {
  QStringList args;
  args << username;
  QProcess passwdProcess;
  passwdProcess.start("sudo", QStringList() << "passwd" << username);
  passwdProcess.waitForStarted();
  passwdProcess.write(newPassword.toUtf8() + "\n");
  passwdProcess.waitForFinished();
  return passwdProcess.exitCode() == 0;
}

QStringList UsersManager::executeCommand(const QString &command) {
  QProcess process;
  process.start("/bin/sh", QStringList() << "-c" << command);
  process.waitForFinished();

  QByteArray output = process.readAllStandardOutput();
  QString outputStr(output);
  QStringList outputList = outputStr.split("\n", QString::SkipEmptyParts);

  return outputList;
}
