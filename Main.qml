import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    visible: true

    function loadMainPage() {
        loaderView.source = "qrc:/MainPage.qml"
    }
    function loadNewGame() {
        loaderView.source = "qrc:/GameSettingsPage.qml"
    }
    function loadGamePage() {
        loaderView.source = "qrc:/GameWindow.qml"
    }

    Loader {
        id: loaderView
        anchors.fill: parent
        source: "qrc:/MainPage.qml"
    }
    Connections {
        target: loaderView.item
        onGoMainPage: loadMainPage()
    }
    Connections {
        target: loaderView.item
        onNewGame: loadNewGame()
    }
    Connections {
        target: loaderView.item
        onStartGame: loadGamePage()
    }
    Connections {
        target: gameState
        onGameReady: {
            console.log("signal onGameReady from Loader");
            loadGamePage();
        }
    }

    Component {
        id: mainPage
        GameWindow{}
    }
}
