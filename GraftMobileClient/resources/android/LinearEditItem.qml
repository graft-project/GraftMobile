import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import "../"

ColumnLayout {
    id: linearEditItem
    property alias title: titleItem.text
    property alias text: editItem.text
    property alias wrapMode: editItem.wrapMode
    property alias inputMethodHints: editItem.inputMethodHints
    property alias validator: editItem.validator
    property alias showLengthIndicator: textCount.visible
    property alias inputMask: editItem.inputMask
    property alias echoMode: editItem.echoMode
    property bool letterCountingMode: true
    property int maximumLength: 32767
    property alias passwordCharacter: editItem.passwordCharacter
    property bool passMode: false
    property bool confirmPass: false
    property bool visibilityIcon: false
    property alias matchPassText: matchText

    onPassModeChanged: {
        visibilityIcon = true
        if (passMode) {
            passwordCharacter = '•'
            editItem.echoMode = TextInput.Password
        } else {
            editItem.echoMode = TextInput.Normal
        }
    }

    spacing: 0

    Text {
        id: titleItem
        Layout.fillWidth: true
        color: "#BBBBBB"
        font.pointSize: 12
    }

    TextField {
        id: editItem
        Layout.fillWidth: true
        verticalAlignment: Qt.AlignTop
        color: "#404040"
        rightPadding: visibilityIcon ? 44 : 0
        maximumLength: letterCountingMode ? linearEditItem.maximumLength : 32767
        Material.accent: confirmPass ? "#f33939" : "#9E9E9E"
        onWrapModeChanged: {
            if (wrapMode === TextField.NoWrap) {
                Layout.fillHeight = false
            } else {
                Layout.fillHeight = true
                Layout.maximumHeight = 200
            }
        }

        VisibilityIcon {
            z: 1
            visible: visibilityIcon
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 6
                bottomMargin: 6
            }
            Material.accent: "#9E9E9E"
            onClicked: passMode =! passMode
        }

        Item {
            height: 20
            width: 40
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
            }
        }
    }

    RowLayout {
        spacing: 0

        Text {
            id: matchText
            font.pointSize: 12
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
        }

        Text {
            id: textCount
            text: qsTr("%1 / %2").arg(letterCountingMode ? editItem.displayText.length :
                                                           wordCounting()).arg(maximumLength)
            color: "#BBBBBB"
            font.pointSize: 12
            Layout.alignment: Qt.AlignRight
        }
    }

    function wordCounting() {
        if (editItem.displayText.length !== 0) {
            var wordList = GraftClient.wideSpacingSimplify(editItem.displayText).split(' ')
            return wordList.length
        } else {
            return 0
        }
    }
}
