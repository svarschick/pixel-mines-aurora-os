import QtQuick 2.0

Item {
    id: numpad
    signal endInput()

    property var getValue: undefined
    property var setValue: undefined
    property int maxValue: 100
    property int minValue: 1

    property string colorText: "black"
    property string colorNums: "black"

    property int gap: 10
    property int scale: 3

    property bool saveEnable: {
        return numpad.minValue <= numpad.currValue && numpad.currValue <= numpad.maxValue
    }

    property int currValue: getValue()

    width: 70 * numpad.scale
    height: 115 * numpad.scale

    function buttonNumsClick(index) {
        if (0 <= index && index <= 8) {
            if (numpad.currValue * 10 + index + 1 < 1000000) {
                numpad.currValue = numpad.currValue * 10 + index + 1;
            }
        }
        if (9 === index) {
            if (numpad.currValue * 10 < 1000000) {
                numpad.currValue = numpad.currValue * 10;
            }
        }
        if (10 === index) {
            numpad.currValue = numpad.currValue / 10;
        }

        if (numpad.minValue <= numpad.currValue && numpad.currValue <= numpad.maxValue) {
            numpad.setValue(numpad.currValue);
            numpad.saveEnable = true;
        } else {
            numpad.saveEnable = false;
        }

        if (11 === index && numpad.saveEnable) {
            endInput();
        }
    }

    Image {
        anchors.fill: parent
        source: constants.textureNumpad
        smooth: false
        antialiasing: false

        MouseArea {
            anchors.fill: parent
            enabled: true
        }

        Text {
            id: vText

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 11 * numpad.scale
            text: numpad.currValue
            color: numpad.colorText
            font {
                family: vars.textFontFamily
                pointSize: 7 * numpad.scale
            }
        }

        Grid {
            id: pad
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30 * numpad.scale

            spacing: 6 * numpad.scale
            columns: 3

            property var buttonsValue: [1,2,3,4,5,6,7,8,9,0,"",""]

            Repeater {
                id: repeater
                anchors.fill: parent

                model: 12
                Image {
                    width: 15 * numpad.scale
                    height: 15 * numpad.scale
                    smooth: false
                    antialiasing: false
                    source: {
                        if (10 === index) return constants.textureEastArrow;
                        if (11 === index) {
                            if (numpad.saveEnable) return constants.textureSaveButton;
                            else return constants.textureSquareButton
                        }
                        return constants.textureSquareButton;
                    }

                    Text {
                        anchors.centerIn: parent
                        text: pad.buttonsValue[index]
                        color: numpad.colorNums
                        font {
                            family: vars.textFontFamily
                            pointSize: 6 * numpad.scale
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: buttonNumsClick(index);
                    }
                }
            }
        }
    }
}
