import QtQuick 2.0

Item {
    id: apadtiveTopMenu
    property real scale: 4
    property real targetWidth: 100

    height: 30 * apadtiveTopMenu.scale
    width: targetWidth <= 52 * apadtiveTopMenu.scale ? 52 * apadtiveTopMenu.scale : targetWidth

    Image {
        id: leftPart
        anchors.top: parent.top
        anchors.left: parent.left
        width: 30 * apadtiveTopMenu.scale
        height: 30 * apadtiveTopMenu.scale
        source: constants.textureTopMenuLeft
        smooth: false
        antialiasing: false
    }
    Image {
        anchors.top: parent.top
        anchors.right: parent.right
        width: 22 * apadtiveTopMenu.scale
        height: 30 * apadtiveTopMenu.scale
        source: constants.textureTopMenuRight
        smooth: false
        antialiasing: false
    }
    Row {
        anchors.left: leftPart.right
        anchors.top: parent
        height: parent.height
        width: targetWidth - (30 + 22) * apadtiveTopMenu.scale
        clip: true

        Repeater {
            anchors.fill: parent
            model: 20

            Image {
                width: 90 * apadtiveTopMenu.scale
                height: 30 * apadtiveTopMenu.scale
                source: constants.textureTopMenuCenter
                smooth: false
                antialiasing: false
            }
        }
    }
}
