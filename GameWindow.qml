import QtQuick 2.0

Item {
    id: gamePage
    signal goMainPage()

    anchors.fill: parent

    QtObject {
        id: constants

        property int cellSize: 50
        property int gridLineWeight: 1
        property int realCellSize: cellSize - gridLineWeight
        property int countVerticalLines: gameSettings.widthMinefield + 1
        property int countHorizontalLines: gameSettings.heightMinefield + 1
        property int fieldHeight: gameSettings.heightMinefield * (realCellSize + gridLineWeight)
        property int fieldWidth: gameSettings.widthMinefield * (realCellSize + gridLineWeight)
        property int widthSpacing: 200
        property int heightSpacing: 200

        property int contentWidthMargin: 300
        property int contentHeightMargin: 300

        property string lineColor: "gray"

        property string minesAroundColor1:       "#0369B4"
        property string minesAroundColor2:       "#028E8F"
        property string minesAroundColor3:       "#018A4F"
        property string minesAroundColor4:       "#C66D1B"
        property string minesAroundColor5:       "#BB1219"
        property string minesAroundColor6:       "#860D74"
        property string minesAroundColor7:       "#4A1D78"
        property string minesAroundColor8:       "#3A085F"
        property string minesAroundColorDefault: "#000000"

        property string darkenBackgroundColor: "#122327"
        property double darkenBackgroundOpacity: 0.3

        property string bgCellTexture1: "qrc:/textures/minefield/snow1.png"
        property string bgCellTexture2: "qrc:/textures/minefield/snow2.png"
        property string flagTexture:    "qrc:/textures/minefield/flag.png"

        property string gameBGTexture:  "qrc:/textures/bg/game_bg_1.jpg"

        property string textFontFamily: "Pixelizer"
        property int textFontPointSize: 14

        property string textLightColor: "#D8E2E3"
        property string textDarkColor:  "#132929"

        property string textureTopMenuLeft: "qrc:/textures/menu/game_top_menu_left.png"
        property string textureTopMenuCenter: "qrc:/textures/menu/game_top_menu_center.png"
        property string textureTopMenuRight: "qrc:/textures/menu/game_top_menu_right.png"
        property string textureMinusButton: "qrc:/textures/menu/minus_button.png"
        property string texturePlusButton: "qrc:/textures/menu/plus_button.png"
        property string textureResizeMenu: "qrc:/textures/menu/resize_menu.png"
        property string textureSettingsButton: "qrc:/textures/menu/settings_button.png"
        property string textureEndGameBackground: "qrc:/textures/menu/end_game_bg.png"
        property string textureBomb: "qrc:/textures/minefield/bomb.png"

        property string textureButton2Left:   "qrc:/textures/menu/button2_left.png"
        property string textureButton2Right:  "qrc:/textures/menu/button2_right.png"
        property string textureButton2Center: "qrc:/textures/menu/button2_center.png"
        property string textureSettingsBackground: "qrc:/textures/menu/settings_bg.png"

        property int scale: 2
    }

    function textureSource(index) {
        switch(index) {
        case 0:  return "qrc:/textures/minefield/cave/stone.png";
        case 1:  return "qrc:/textures/minefield/cave/coal_ore.png";
        case 2:  return "qrc:/textures/minefield/cave/coarse_dirt.png";
        case 3:  return "qrc:/textures/minefield/cave/copper_ore.png";
        case 4:  return "qrc:/textures/minefield/cave/deepslate.png";
        case 5:  return "qrc:/textures/minefield/cave/deepslate_coal_ore.png";
        case 6:  return "qrc:/textures/minefield/cave/deepslate_copper_ore.png";
        case 7:  return "qrc:/textures/minefield/cave/deepslate_iron_ore.png";
        case 8:  return "qrc:/textures/minefield/cave/dirt.png";
        case 9:  return "qrc:/textures/minefield/cave/iron_ore.png";
        case 10: return "qrc:/textures/minefield/cave/amethyst_block.png";
        default: return "qrc:/textures/minefield/cave/stone.png";
        }
    }
    function textColor(value) {
        switch(value) {
        case 1:  return constants.minesAroundColor1;
        case 2:  return constants.minesAroundColor2;
        case 3:  return constants.minesAroundColor3;
        case 4:  return constants.minesAroundColor4;
        case 5:  return constants.minesAroundColor5;
        case 6:  return constants.minesAroundColor6;
        case 7:  return constants.minesAroundColor7;
        case 8:  return constants.minesAroundColor8;
        default: return constants.minesAroundColorDefault;
        }
    }

    QtObject {
        id: controls

        property double scale: 2
        property double scaleStep: 0.25
    }

    // bg
    Image {
        z: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.Pad

        source: constants.gameBGTexture
    }

    // header
    Item {
        id: header
        z: 2
        property int headerHeight: 100

        anchors.fill: parent

        AdaptiveTopMenu {
            anchors.top: parent.top
            anchors.left: parent.left
            scale: 4 * constants.scale
            targetWidth: parent.width
            height: 20 * 4 * constants.scale// height pure top menu

            Item {
                width: 100 * constants.scale
                height: 50 * constants.scale
                anchors.centerIn: parent

                Text {
                    id: flagsText
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "флаги: " + gameState.flagSetted + "|" + gameState.totalMines
                    color: constants.textLightColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        family: constants.textFontFamily
                        pointSize: constants.textFontPointSize * constants.scale
                    }

                }

                Text {
                    id: scoreText
                    anchors.top: flagsText.bottom
                    anchors.topMargin: 5 * constants.scale
                    anchors.left: flagsText.left
                    anchors.right: flagsText.right

                    text: "счёт: " + gameState.score
                    color: constants.textLightColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        family: constants.textFontFamily
                        pointSize: constants.textFontPointSize * constants.scale
                    }
                }
            }
        }

        Image {
            id: settingsbutton
            signal openSettingsWindow()

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10 * constants.scale
            source: constants.textureSettingsButton
            smooth: false
            antialiasing: false

            width: 15 * 4 * constants.scale
            height: 15 * 4 * constants.scale

            MouseArea {
                anchors.fill: parent
                onClicked: settingsbutton.openSettingsWindow()
            }
        }
    }

    // left control panel
    Item {
        id: leftPanel
        z: 2

        property int bottomShift: 100
        property real menuMultiplySize: 1.1

        anchors.fill: parent

        Image {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 100
            anchors.leftMargin: 10

            source: constants.textureResizeMenu
            smooth: false
            antialiasing: false
            width: 19 * 4 * leftPanel.menuMultiplySize * constants.scale
            height: 54 * 4 * leftPanel.menuMultiplySize * constants.scale

            MouseArea {
                anchors.fill: parent
                enabled: true
            }

            Text {
                id: minefieldSizeText
                anchors.top: parent.top
                anchors.topMargin: 6 * 4 * leftPanel.menuMultiplySize * constants.scale
                anchors.horizontalCenter: parent.horizontalCenter
                text: (controls.scale * 100)
                color: constants.textLightColor
                font {
                    family: constants.textFontFamily
                    pointSize: constants.textFontPointSize * constants.scale
                }
            }
            Image {
                id: minusButton
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: minefieldSizeText.bottom
                anchors.topMargin: 3 * 4 * leftPanel.menuMultiplySize * constants.scale
                width: 15 * 4 * leftPanel.menuMultiplySize * constants.scale
                height: 15 * 4 * leftPanel.menuMultiplySize * constants.scale
                source: constants.texturePlusButton
                smooth: false
                antialiasing: false

                MouseArea {
                    anchors.fill: parent
                    enabled: true
                    onClicked: {
                        if (controls.scale < 3)
                            controls.scale += controls.scaleStep
                    }
                }
            }
            Image {
                id: plusButton
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: minusButton.bottom
                anchors.topMargin: 5 * 4 * leftPanel.menuMultiplySize * constants.scale
                width: 15 * 4 * leftPanel.menuMultiplySize * constants.scale
                height: 15 * 4 * leftPanel.menuMultiplySize * constants.scale
                source: constants.textureMinusButton
                smooth: false
                antialiasing: false

                MouseArea {
                    anchors.fill: parent
                    enabled: true
                    onClicked: {
                        if (controls.scaleStep < controls.scale)
                            controls.scale -= controls.scaleStep
                    }
                }
            }
        }
    }

    // draw cell
    Item {
        anchors.fill: parent
        anchors.centerIn: parent
        id: cells
        z: 1

        Flickable {
            id: flickable

            anchors.fill: parent
            anchors.centerIn: parent

            contentWidth: (constants.fieldWidth) * controls.scale + constants.contentWidthMargin
            contentHeight: (constants.fieldHeight) * controls.scale + header.headerHeight + constants.contentHeightMargin

            onContentWidthChanged: centerView()
            onContentHeightChanged: centerView()

            function centerView() {
                console.log("contentX: " + flickable.contentX + " ; contentY: " + flickable.contentY)
                console.log("width: " + gameSettings.widthMinefield + " ; height: " + gameSettings.heightMinefield)
                flickable.contentX = flickable.contentX
                flickable.contentY = flickable.contentY
            }

            clip: true

            Item {
                width: (constants.fieldWidth) * controls.scale + constants.contentWidthMargin
                height: (constants.fieldHeight) * controls.scale + constants.contentHeightMargin
                anchors.bottom: parent.bottom

                Grid {
                    rows: gameSettings.heightMinefield
                    anchors.centerIn: parent

                    Repeater {
                        model: uiCellModel
                        delegate: cell
                    }
                }
            }


        }
    }

    // cell component
    Component {
        id: cell

        Rectangle {
            width: constants.cellSize * controls.scale
            height: constants.cellSize * controls.scale
            color: "transparent"

            Image {
                visible: true
                anchors.fill: parent
                source: {
                    if (!model.isRevealed) return textureSource(model.texture)
                    else return constants.bgCellTexture1
                }

                smooth: false
                antialiasing: false
            }
            Text {
                visible: model.isRevealed
                anchors.centerIn: parent
                font {
                    family: constants.textFontFamily
                    pointSize: constants.textFontPointSize * controls.scale
                }
                text: {
                    if (0 === model.value || 9 === model.value) return ""
                    else return model.value
                }
                color: textColor(model.value)
            }
            Loader {
                visible: model.isRevealed
                anchors.fill: parent
                active: 9 === model.value
                sourceComponent: Image {
                    anchors.fill: parent
                    smooth: false
                    antialiasing: false
                    source: constants.textureBomb
                }
            }

            Image {
                visible: model.hasFlag
                anchors.fill: parent
                source: constants.flagTexture
                smooth: false
                antialiasing: false
            }
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border {
                    color: constants.lineColor
                    width: constants.gridLineWeight * controls.scale
                    pixelAligned: false
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    cellTimer.start()
                }
                onReleased: {
                    cellTimer.stop();
                    console.log("on released");
                    if (!cellTimer.isTriggered)
                        uiCellModel.clickCell(index);
                    cellTimer.isTriggered = false;
                }
                onCanceled: {
                    cellTimer.stop();
                    console.log("on canseled");
                    cellTimer.isTriggered = false
                }
            }
            Timer {
                id: cellTimer
                property bool isTriggered: false

                interval: 500
                onTriggered: {
                    uiCellModel.setFlagCell(index);
                    isTriggered = true;
                    console.log("long hold");
                }
            }
        }
    }

    // settings window
    Item {
        id: settingsWindow
        z: 4
        anchors.fill: parent

        property bool nvanish: false
        property string message: ""

        Rectangle {
            visible: settingsWindow.nvanish
            anchors.fill: parent
            color: constants.darkenBackgroundColor
            opacity: constants.darkenBackgroundOpacity

            MouseArea {
                anchors.fill: parent
            }
        }
        Image {
            anchors.centerIn: parent
            width: 60 * 4 * constants.scale
            height: 80 * 4 * constants.scale
            visible: settingsWindow.nvanish
            source: constants.textureSettingsBackground
            smooth: false
            antialiasing: false

            Column {
                anchors.centerIn: parent
                spacing: 5 * 4 * constants.scale
                AdaptiveButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    targetWidth: 200 * constants.scale
                    scale: 4 * constants.scale

                    Text {
                        anchors.centerIn: parent
                        text: "назад к игре"
                        color: constants.textLightColor
                        font {
                            family: constants.textFontFamily
                            pointSize: constants.textFontPointSize * 1.3 * constants.scale
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: settingsWindow.nvanish = false
                    }
                }
                AdaptiveButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    targetWidth: 200 * constants.scale
                    scale: 4 * constants.scale

                    Text {
                        anchors.centerIn: parent
                        text: "выход"
                        color: constants.textLightColor
                        font {
                            family: constants.textFontFamily
                            pointSize: constants.textFontPointSize * 1.3 * constants.scale
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: gamePage.goMainPage()
                    }
                }
            }
        }

        Connections {
            target: settingsbutton
            onOpenSettingsWindow: settingsWindow.nvanish = true
        }
    }

    // end game window
    Item {
        z: 5
        id: endGameWindow
        anchors.fill: parent

        property bool darken: false
        property string message: ""

        Rectangle {
            visible: endGameWindow.darken
            anchors.fill: parent
            color: constants.darkenBackgroundColor
            opacity: constants.darkenBackgroundOpacity

            MouseArea {
                anchors.fill: parent
            }
        }
        Image {
            visible: endGameWindow.darken
            anchors.centerIn: parent
            width: 60 * 4 * constants.scale
            height: 80 * 4 * constants.scale
            source: constants.textureEndGameBackground
            smooth: false
            antialiasing: false

            Item {
                anchors {
                    top: parent.top
                    left: parent.left
                    margins: 8 * 4 * constants.scale
                }

                width: 44 * 4 * constants.scale
                height: 44 * 4 * constants.scale

                Column {
                    anchors.centerIn: parent
                    spacing: 20 * constants.scale

                    Text {
                        // shadow
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: endGameWindow.message
                        color: constants.textDarkColor
                        font {
                            family: constants.textFontFamily
                            pointSize: constants.textFontPointSize * 1.3 * constants.scale
                        }

                        // main text
                        Text {
                            anchors {
                                topMargin: -1 * 4 * constants.scale
                                top: parent.top
                                left: parent.left
                                leftMargin: 1 * 4 * constants.scale
                            }
                            text: endGameWindow.message
                            color: constants.textLightColor
                            font {
                                family: constants.textFontFamily
                                pointSize: constants.textFontPointSize * 1.3 * constants.scale
                            }
                        }
                    }
                    Text {
                        // shadow
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "счёт: " + gameState.score
                        color: constants.textDarkColor
                        font {
                            family: constants.textFontFamily
                            pointSize: constants.textFontPointSize * 1.3 * constants.scale
                        }

                        // main text
                        Text {
                            anchors {
                                topMargin: -1 * 4 * constants.scale
                                top: parent.top
                                left: parent.left
                                leftMargin: 1 * 4 * constants.scale
                            }
                            text: "счёт: " + gameState.score
                            color: constants.textLightColor
                            font {
                                family: constants.textFontFamily
                                pointSize: constants.textFontPointSize * 1.3 * constants.scale
                            }
                        }
                    }
                }
            }


            AdaptiveButton {
                targetWidth: 44 * 4 * constants.scale
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 5 * 4 * constants.scale
                }

                scale: 4

                Text {
                    anchors.centerIn: parent
                    color: constants.textLightColor
                    text: "меню"
                    font {
                        family: constants.textFontFamily
                        pointSize: constants.textFontPointSize * 1.5 * constants.scale
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: gamePage.goMainPage()
                }
            }
        }

        Connections {
            target: gameState
            onYouWin: {
                console.log("qml: you win")
                endGameWindow.darken = true
                endGameWindow.message = "победа"
            }
            onYouLose: {
                console.log("qml: you lose")
                endGameWindow.darken = true
                endGameWindow.message = "поражение"
            }
        }
    }

}
