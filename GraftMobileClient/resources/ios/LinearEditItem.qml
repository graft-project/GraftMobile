import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import "../"

BaseLinearEditItem {
    id: linearEditItem
    property alias title: titleItem.text
    property alias text: editItem.text
    property alias wrapMode: editItem.wrapMode
    property alias inputMethodHints: editItem.inputMethodHints
    property alias validator: editItem.validator
    property alias showLengthIndicator: textCount.visible
    property alias inputMask: editItem.inputMask
    property alias echoMode: editItem.echoMode
    property alias passwordCharacter: editItem.passwordCharacter
    property alias attentionText: attentionText.text
    property bool inlineTitle: false

    onPasswordModeChanged: {
        visibilityIcon = true
        if (passwordMode) {
            passwordCharacter = '•'
            editItem.echoMode = TextInput.Password
        } else {
            editItem.echoMode = TextInput.Normal
            editItem.inputMethodHints = Qt.ImhHiddenText
        }
    }

    Item {
        id: field
        Layout.fillWidth: true
        Layout.preferredHeight: 46

        TextField {
            id: editItem
            anchors {
                fill: parent
                bottomMargin: -12
            }
            leftPadding: titleItem.width
            rightPadding: visibilityIcon ? 42 : 0
            bottomPadding: 30
            verticalAlignment: Qt.AlignTop
            color: "#404040"
            maximumLength: letterCountingMode ? linearEditItem.maximumLength : 32767
            Material.accent: wrongFieldColor ? "#F33939" : "#9E9E9E"
            onWrapModeChanged: field.resizeField()
        }

        Text {
            id: titleItem
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
                topMargin: 8
            }
            font.pixelSize: editItem.font.pixelSize
            rightPadding: 5
            color: "#8E8E93"
        }

        VisibilityIcon {
            visible: visibilityIcon
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 6
            }
            onClicked: passwordMode =! passwordMode
        }

        function resizeField() {
            if (editItem.wrapMode === TextField.NoWrap) {
                Layout.fillHeight = false
            } else {
                Layout.fillHeight = true
                if (!inlineTitle) {
                    editItem.topPadding = 30
                    editItem.leftPadding = 0
                    Layout.maximumHeight = 200
                }
            }
        }
    }

    RowLayout {
        spacing: 0

        Text {
            id: attentionText
            Layout.alignment: Qt.AlignLeft
            visible: visibilityIcon
            font.pixelSize: 12
            color: wrongFieldColor ? "#F33939" : "#3F3F3F"
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            id: textCount
            Layout.alignment: Qt.AlignRight
            text: qsTr("%1/%2").arg(letterCountingMode ? editItem.length :
                                                         wordCounting()).arg(maximumLength)
            color: "#8E8E93"
            font.pixelSize: 12
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
