import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

ColumnLayout {
    property alias attentionText: attentionText.text
    property alias showLengthIndicator: textCount.visible
    property bool visibilityIcon: false
    property bool passwordMode: false
    property bool wrongFieldColor: false
    property bool letterCountingMode: true
    property int maximumLength: 32767
    property alias titleTextField: titleTextField.children
    property alias baseTextField: baseTextField.children

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
        id: titleTextField
        Layout.fillWidth: true
        Layout.preferredHeight: Qt.platform.os === "ios" ? 0 : 10
    }

    Item {
        id: baseTextField
        Layout.fillWidth: true
        Layout.preferredHeight: editItem.wrapMode === TextField.NoWrap ? 40 : 94
    }

    RowLayout {
        spacing: 0
        Layout.fillWidth: true
        Layout.preferredHeight: 15
        Rectangle {
            anchors.fill: parent
            color: "#6009ff1d"
        }

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
            text: qsTr("%1 / %2").arg(letterCountingMode ? editItem.displayText.length :
                                                           wordCounting()).arg(maximumLength)
            color: Qt.platform.os === "ios" ? "#8E8E93" : "#BBBBBB"
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
