import QtQuick 2.0
import Sailfish.Silica 1.0

// qwerty asdfgh zxcvbn

ApplicationWindow {
    objectName: "applicationWindow"
    initialPage: Qt.resolvedUrl("qrc:/Main.qml")
    cover: Qt.resolvedUrl("cover/DefaultCoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
