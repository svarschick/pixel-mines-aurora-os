import QtQuick 2.0

Item {
    id: apadtiveButton
    property real scale: 4
    property real targetWidth: 100

    height: 20 * scale
    width: targetWidth <= 44 * apadtiveButton.scale ? 44 * apadtiveButton.scale : targetWidth

    Image {
        z: 0
        id: leftPart
        anchors.top: parent.top
        anchors.left: parent.left
        width: 20 * apadtiveButton.scale
        height: 20 * apadtiveButton.scale
        source: constants.textureButton2Left
        smooth: false
        antialiasing: false
    }
    Image {
        z: -1
        anchors.top: parent.top
        anchors.right: parent.right
        width: 40 * apadtiveButton.scale
        height: 20 * apadtiveButton.scale
        source: constants.textureButton2Right
        smooth: false
        antialiasing: false
    }
    Row {
        z: -2
        anchors.left: leftPart.right
        anchors.top: parent
        height: parent.height
        width: targetWidth - 44 * apadtiveButton.scale
        clip: true

        Repeater {
            anchors.fill: parent
            model: 20

            Image {
                width: 70 * apadtiveButton.scale
                height: 20 * apadtiveButton.scale
                source: constants.textureButton2Center
                smooth: false
                antialiasing: false
            }
        }
    }
}
