import QtQuick 2.0

Item {
    id: control
    signal callNumpad()

    property alias label: labelText.text
    property int scale: 1
    property int minValue: 1
    property int maxValue: 100
    property var getValue: undefined
    property var setValue: undefined
    property var onIncrement: undefined
    property var onDecrement: undefined
    width: parent ? parent.width : 200
    height: 40 * scale
    z: 2

    Text {
        id: labelText
        anchors.left: parent.left
        text: "param:"
        color: vars.colorText
        font {
            family: vars.textFontFamily
            pointSize: vars.textFontPointSize
        }
    }

    Item {
        id: downButton
        width: 40 * scale
        height: 40 * scale
        anchors.right: parent.right

        Image {
            anchors.fill: parent
            source: constants.textureSouthArrow
            smooth: false
            antialiasing: false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (getValue() > minValue) {
                    if (onDecrement) onDecrement()
                }
            }
        }
    }

    Item {
        id: upButton
        width: 40 * scale
        height: 40 * scale
        anchors.right: downButton.left
        anchors.rightMargin: 20 * scale

        Image {
            anchors.fill: parent
            source: constants.textureNortArrow
            smooth: false
            antialiasing: false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (getValue() < maxValue) {
                    if (onIncrement) onIncrement()
                }
            }
        }
    }

    Text {
        anchors.right: upButton.left
        anchors.rightMargin: 30 * scale
        text: getValue()
        color: vars.colorDarkText
        font {
            family: vars.textFontFamily
            pointSize: vars.textFontPointSize * scale
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                callNumpad()
            }
        }
    }
}
