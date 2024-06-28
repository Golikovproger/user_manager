#include "users.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;
  qmlRegisterType<UsersManager>("Users", 1, 0, "Users");
  const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

  qmlRegisterSingletonType(QUrl("qrc:/qml/theme/Theme.qml"), "Theme", 1, 0,
                           "Theme");

  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                   [url](QObject *obj, const QUrl &objUrl) {
                     if (!obj && url == objUrl)
                       QCoreApplication::exit(-1);
                   },
                   Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
