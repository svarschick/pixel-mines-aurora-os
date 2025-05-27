import QtQuick 2.0

Item {
    id: mainPage
    signal newGame()

    QtObject {
        id: constants
        property string textureButton1: "qrc:/textures/menu/button1.png"
        property string textureLogo: "qrc:/textures/menu/logo.png"
        property string colorDarkText: "#081515"
    }

    QtObject {
        id: vars

        property string textureBG: "qrc:/textures/bg/main_bg_1.jpg"

        property string textSaperFontFamily: "Pixelizer"
        property int    textSaperFontPointSize: 72
        property string textButtonFontFamily: "Pixelizer"
        property int    textButtonFontPointSize: 30 * 2
        property string colorRectangleButton: "white"
    }

    Image {
        z: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.Pad

        source: vars.textureBG
    }

    Image {
        z: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.margins: parent.height / 20
        height: 350 * 1.75
        width: 450 * 1.75
        source: constants.textureLogo
        smooth: false
        antialiasing: false
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottomMargin: 200
        spacing: 50

        Image {
            width: 350 * 1.75
            height: 100 * 1.75
            source: constants.textureButton1
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: false
            antialiasing: false

            Text {
                anchors.centerIn: parent
                text: "новая игра"
                color: constants.colorDarkText
                font {
                    pointSize: vars.textButtonFontPointSize
                    family: vars.textButtonFontFamily
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: newGame()
            }
        }
//        Image {
//            width: 350 * 1.75
//            height: 100 * 1.75
//            source: constants.textureButton1
//            anchors.horizontalCenter: parent.horizontalCenter
//            smooth: false
//            antialiasing: false

//            Text {
//                anchors.centerIn: parent
//                color: constants.colorDarkText
//                text: "настройки"
//                font {
//                    pointSize: vars.textButtonFontPointSize
//                    family: vars.textButtonFontFamily
//                }
//            }
//        }
    }
}
