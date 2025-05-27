import QtQuick 2.0

Item {
    id: apadtiveFooterButton
    property real scale: 4
    property real targetWidth: 100

    height: 50 * apadtiveFooterButton.scale
    width: targetWidth <= 98 * apadtiveFooterButton.scale ? 98 * apadtiveFooterButton.scale : targetWidth

    Image {
        id: leftPart
        anchors.top: parent.top
        anchors.left: parent.left
        width: 15 * apadtiveFooterButton.scale
        height: 50 * apadtiveFooterButton.scale
        source: constants.textureFooterButtonLeft
        smooth: false
        antialiasing: false
    }
    Image {
        anchors.top: parent.top
        anchors.right: parent.right
        width: 83 * apadtiveFooterButton.scale
        height: 50 * apadtiveFooterButton.scale
        source: constants.textureFooterButtonRight
        smooth: false
        antialiasing: false
    }
    Row {
        anchors.left: leftPart.right
        anchors.top: parent
        height: parent.height
        width: targetWidth - (83 + 15) * apadtiveFooterButton.scale
        clip: true

        Repeater {
            anchors.fill: parent
            model: 20

            Image {
                width: 100 * apadtiveFooterButton.scale
                height: 50 * apadtiveFooterButton.scale
                source: constants.textureFooterButtonCenter
                smooth: false
                antialiasing: false
            }
        }
    }
}
