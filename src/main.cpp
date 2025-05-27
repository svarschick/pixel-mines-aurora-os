#include <auroraapp.h>
#include <QtQuick>
#include <QQmlContext>
#include <QQmlComponent>
#include <QSharedPointer>
#include <QFontDatabase>
#include <QString>
#include <QDebug>
#include <iostream>
#include <memory>
#include <QQmlApplicationEngine>

#include "UICellModel.h"
#include "GameSettings.h"
#include "GameState.h"

using namespace minesweeper;

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("ru.template"));
    application->setApplicationName(QStringLiteral("kur"));

    QScopedPointer<QQuickView> view(Aurora::Application::createView());

    int id = QFontDatabase::addApplicationFont(":/fonts/PixelizerBold.ttf");
    if (id < 0) {
        qDebug() << "font not loaded";
    }
    QString fontFamily = QFontDatabase::applicationFontFamilies(id).at(0);
    qDebug() << fontFamily;

    QSharedPointer<GameSettings> gameSettings_p{new GameSettings(10, 10, 1)};
    QSharedPointer<GameState> gs_p{new GameState()};
    gs_p->initial(gameSettings_p, &(*view));
    gs_p->start();

    view->rootContext()->setContextProperty("uiCellModel", &(*gs_p->getUICellModel()));
    view->rootContext()->setContextProperty("gameSettings", &(*gameSettings_p));
    view->rootContext()->setContextProperty("gameState", &(*gs_p));

    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/kur.qml")));
    view->show();

    return application->exec();
}
