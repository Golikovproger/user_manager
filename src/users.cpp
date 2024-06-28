#include "users.h"
#include <QProcess>

UsersManager::UsersManager(QObject *parent) : QObject(parent) {}

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

QStringList UsersManager::getGroupsList() {
  //  return executeCommand("getent group | cut -d: -f1");
  QString getGroupsScript = "awk -F: '{ printf \"%s\\n\", $1}' /etc/group";
  return executeCommand(getGroupsScript);
}

bool UsersManager::addUser(const QString &username) {
  QStringList args;
  args << "-m" << username;
  return QProcess::execute("sudo", args) == 0;
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
  //  process.start(command);
  process.waitForFinished();
  QByteArray output = process.readAllStandardOutput();
  QString outputStr(output);
  return outputStr.split("\n", QString::SkipEmptyParts);
}
