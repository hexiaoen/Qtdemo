#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include "client.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<client>("he.qt.client", 1, 0, "Client");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();

}

