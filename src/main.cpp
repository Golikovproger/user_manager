#include "users.h"
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QSurfaceFormat>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  QSurfaceFormat format;
  format.setSwapInterval(0);
  QSurfaceFormat::setDefaultFormat(format);

  qmlRegisterType<UsersManager>("Users", 1, 0, "Users");
  const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

  qmlRegisterSingletonType(QUrl("qrc:/qml/theme/Theme.qml"), "Theme", 1, 0,
                           "Theme");

  app.setApplicationName("User & Groups");
  app.setWindowIcon(QIcon(":/assets/desktop_icon.png"));

  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                   [url](QObject *obj, const QUrl &objUrl) {
                     if (!obj && url == objUrl)
                       QCoreApplication::exit(-1);
                   },
                   Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
