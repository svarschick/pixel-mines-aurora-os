import QtQuick 2.0
import QtQml 2.2

Item {
    id: gameSettingsPage

    signal goMainPage()
    signal startGame()

    QtObject {
        id: constants

        property string textureNortArrow:     "qrc:/textures/menu/arrow_nort.png"
        property string textureEastArrow:     "qrc:/textures/menu/arrow_east.png"
        property string textureSouthArrow:    "qrc:/textures/menu/arrow_south.png"
        property string textureNumpad:        "qrc:/textures/menu/numpad_bg.png"
        property string textureSquareButton:  "qrc:/textures/menu/square_button.png"
        property string textureSaveButton:    "qrc:/textures/menu/save_button.png"

        property string textureButton2Left:   "qrc:/textures/menu/button2_left.png"
        property string textureButton2Right:  "qrc:/textures/menu/button2_right.png"
        property string textureButton2Center: "qrc:/textures/menu/button2_center.png"

        property string textureFooterButtonLeft:   "qrc:/textures/menu/footer_button_left.png"
        property string textureFooterButtonRight:  "qrc:/textures/menu/footer_button_right.png"
        property string textureFooterButtonCenter: "qrc:/textures/menu/footer_button_center.png"

        property string colorDarkenBackground: "#122327"
        property real   colorDarkenBackgroundOpacity: 0.3
        property string colorDarkText: "#081515"
        property string colorLightText: "#D8E2E3"
    }

    QtObject {
        id: vars

        property string textureBG: "qrc:/textures/bg/main_bg_1.jpg"

        property string textNewGameFontFamily: "Pixelizer"
        property int    textNewGameFontPointSize: 30 * 2
        property string textButtonFontFamily: "Pixelizer"
        property int    textButtonFontPointSize: 30 * 2
        property string textFontFamily: "Pixelizer"
        property int    textFontPointSize: 20 * 2

        property string colorSaperText: constants.colorLightText

        property string colorBackButton: constants.colorLightText
        property string colorButton: constants.colorLightText
        property string colorTextBackbutton: constants.colorDarkText
        property string colorTextNewGame: constants.colorLightText
        property string colorTextButton: constants.colorDarkText
        property string colorText: constants.colorLightText

        property string colorScrollBarLine: constants.colorDarkText
        property string colorScrollBarBlock: constants.colorLightText


    }

    property var presets: [
        // name, width, height, mines
        ["чайник",        10, 10, 10],
        ["самовар",       20, 20, 80],
        ["электрочайник", 30, 30, 200],
        ["кофеварка",     50, 50, 400]
    ]
    function gamePresets(presetID, propertyID) {
        return presets[presetID][propertyID]
    }
    function setGameSettings(presetID) {
        currSettings.currWidth  = gamePresets(presetID, 1)
        currSettings.currHeight = gamePresets(presetID, 2)
        currSettings.currMines  = gamePresets(presetID, 3)
    }

    QtObject {
        id: currSettings

        property int currWidth: 10
        property int currHeight: 10
        property int currMines: 10

        onCurrWidthChanged: {
            if (currWidth * currHeight - 1 < currMines)
                currMines = currWidth * currHeight - 1
        }
        onCurrHeightChanged: {
            if (currWidth * currHeight - 1 < currMines)
                currMines = currWidth * currHeight - 1
        }
    }

    Image {
        z: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.Pad

        source: vars.textureBG
    }

    Item {
        id: columnWrapper
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: startGameButton.top
        clip: true

        Column {
            id: column
            anchors.fill: parent
            anchors.margins: 30
            spacing: 30 * 2
            clip: true

            Item {
                id: topLine
                width: parent.width
                height: 40 * 2

                Image {
                    id: backButton

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    width: parent.height
                    height: parent.height

                    source: constants.textureEastArrow
                    smooth: false
                    antialiasing: false

                    MouseArea {
                        anchors.fill: parent
                        onClicked: goMainPage()
                    }
                }
                Text {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: backButton.right
                    anchors.leftMargin: 10 * 3
                    anchors.topMargin: 2

                    color: vars.colorTextNewGame
                    text: "новая игра"
                    font {
                        pointSize: vars.textNewGameFontPointSize
                        family: vars.textButtonFontFamily
                    }
                }
            }

            Text {
                text: "параметры"
                color: vars.colorText
                font {
                    family: vars.textFontFamily
                    pointSize: vars.textFontPointSize
                }
            }

            Item {
                id: paramRows
                width: parent.width
                height: 150

                Column {
                    spacing: 10
                    anchors.fill: parent

                    ParamControl {
                        id: widthLine
                        label: "ширина:"
                        scale: 2
                        getValue: function() { return currSettings.currWidth; }
                        setValue: function(v) { currSettings.currWidth = v; }
                        maxValue: 100
                        onIncrement: function() { currSettings.currWidth += 1; }
                        onDecrement: function() { currSettings.currWidth -= 1; }
                    }

                    ParamControl {
                        id: heightLine
                        label: "высота:"
                        scale: 2
                        getValue: function() { return currSettings.currHeight; }
                        setValue: function(v) { currSettings.currHeight = v; }
                        maxValue: 100
                        onIncrement: function() { currSettings.currHeight += 1; }
                        onDecrement: function() { currSettings.currHeight -= 1; }
                    }

                    ParamControl {
                        id: minesLine
                        label: "мины:"
                        scale: 2
                        getValue: function() { return currSettings.currMines; }
                        setValue: function(v) { currSettings.currMines = v; }
                        maxValue: 100
                        onIncrement: function() { currSettings.currMines += 1; }
                        onDecrement: function() { currSettings.currMines -= 1; }
                    }
                }
            }

            Item {
                width: parent.width
                height: 10
            }

            Text {
                text: "пресеты"
                color: vars.colorText
                font {
                    family: vars.textFontFamily
                    pointSize: vars.textFontPointSize
                }
            }

            Item {
                id: presetsView
                width: parent.width
                height: startGameButton.y - presetsView.y - 30
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true

                Item {
                    id: listViewPresets
                    width: parent.width - 30
                    height: parent.height - 30
                    anchors.left: parent.left
                    anchors.top: parent.top

                    ListView {
                        id: listView
                        anchors.fill: parent
                        spacing: 20

                        model: 4
                        cacheBuffer: 10
                        delegate: AdaptiveButton {
                            scale: 4
                            targetWidth: parent.width

                            Text {
                                anchors.centerIn: parent
                                text: gamePresets(index, 0)
                                color: vars.colorTextButton
                                font {
                                    family: vars.textFontFamily
                                    pointSize: vars.textFontPointSize
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    setGameSettings(index);
                                }
                            }
                        }
                    }
                }
                Item {
                    id: scrollBarPresets
                    width: 30
                    height: parent.height
                    anchors.top: parent.top

                    anchors.right: parent.right
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        width: 10
                        color: vars.colorScrollBarLine
                    }
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 28
                        height: 28
                        color: vars.colorScrollBarBlock
                        y: parent.height * listView.visibleArea.yPosition
                    }
                }
            }
        }
    }

    // connect pad with nums property
    Connections {
        target: widthLine
        onCallNumpad: {
            numpad.visible = true
            numpad.setValue = widthLine.setValue
            numpad.getValue = widthLine.getValue
            numpad.maxValue = widthLine.maxValue
            numpad.currValue = currSettings.currWidth
            padDarken.visible = true
        }
    }
    Connections {
        target: heightLine
        onCallNumpad: {
            numpad.visible = true
            numpad.setValue = heightLine.setValue
            numpad.getValue = heightLine.getValue
            numpad.maxValue = heightLine.maxValue
            numpad.currValue = currSettings.currHeight
            padDarken.visible = true
        }
    }
    Connections {
        target: minesLine
        onCallNumpad: {
            numpad.visible = true
            numpad.setValue = minesLine.setValue
            numpad.getValue = minesLine.getValue
            numpad.maxValue = currSettings.currWidth * currSettings.currHeight - 1
            numpad.currValue = currSettings.currMines
            padDarken.visible = true
        }
    }
    Rectangle {
        z: 10
        id: padDarken
        anchors.fill: parent
        color: constants.colorDarkenBackground
        opacity: constants.colorDarkenBackgroundOpacity
        visible: false

        MouseArea {
            anchors.fill: parent
            enabled: parent.visible
        }
    }

    Numpad {
        id: numpad
        z: 10

        anchors.centerIn: parent
        visible: false
        setValue: undefined
        getValue: undefined
        scale: 8
    }
    Connections {
        target: numpad
        onEndInput: {
            numpad.visible = false
            padDarken.visible = false
        }
    }

//    Rectangle {
//        z: 10
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        width: 300
//        height: 300
//        color: "black"

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                gameSettings.setProperties(currSettings.currHeight, currSettings.currWidth, currSettings.currMines);
//                startGame();
//                console.log("start game clicked");
//            }
//        }
//    }

    AdaptiveFooterButton {
        id: startGameButton
        anchors.bottom: parent.bottom
        scale: 4
        targetWidth: parent.width

        Text {
            text: "начать!"
            anchors.centerIn: parent
            color: vars.colorTextButton
            font {
                family: vars.textFontFamily
                pointSize: vars.textFontPointSize * 2
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("!button start clicked!");
                gameSettings.setProperties(currSettings.currHeight, currSettings.currWidth, currSettings.currMines);
                startGame();
            }
        }
    }


}
