#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <box2dplugin.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Box2DPlugin plugin;
    plugin.registerTypes("Box2DStatic");

    engine.load(QUrl(QStringLiteral("qrc:/ui.qml")));

    return app.exec();
}
