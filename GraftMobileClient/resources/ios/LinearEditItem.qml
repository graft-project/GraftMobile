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
    property bool passwordMode: false
    property bool wrongFieldColor: false
    property bool visibilityIcon: false
    property alias attentionText: attentionText

    spacing: 0
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
            rightPadding: 5
            font.pointSize: editItem.font.pointSize
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
                editItem.topPadding = 30
                editItem.leftPadding = 0
                Layout.fillHeight = true
                Layout.maximumHeight = 200
            }
        }
    }

    RowLayout {
        spacing: 0

        Text {
            id: attentionText
            Layout.alignment: Qt.AlignLeft
            visible: visibilityIcon
            font.pointSize: 12
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
            font.pointSize: 12
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
