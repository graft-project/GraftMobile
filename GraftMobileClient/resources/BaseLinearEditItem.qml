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
    default property alias baseTextField: baseTextField.data
    property var actionTextField: null

    spacing: 0
    onPasswordModeChanged: {
        visibilityIcon = true
        if (passwordMode) {
            actionTextField.passwordCharacter = '•'
            actionTextField.echoMode = TextInput.Password
        } else {
            actionTextField.echoMode = TextInput.Normal
            actionTextField.inputMethodHints = Qt.ImhHiddenText
        }
    }

    Item {
        id: baseTextField
        Layout.fillWidth: true
        Layout.preferredHeight: heightTextField()
    }

    RowLayout {
        spacing: 0
        Layout.fillWidth: true
        Layout.preferredHeight: 15

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
            text: qsTr("%1 / %2").arg(letterCountingMode ? actionTextField.displayText.length :
                                                           wordCounting(actionTextField.displayText)).arg(maximumLength)
            color: Qt.platform.os === "ios" ? "#8E8E93" : "#BBBBBB"
            font.pixelSize: 12
        }
    }

    function wordCounting(textField) {
        if (textField.length !== 0) {
            var wordList = GraftClient.wideSpacingSimplify(textField).split(' ')
            return wordList.length
        } else {
            return 0
        }
    }

    function heightTextField() {
        var size
        if (Qt.platform.os === "ios") {
            size = actionTextField.wrapMode === TextField.NoWrap ? 45 : 102
        } else {
            size = actionTextField.wrapMode === TextField.NoWrap ? 50 : 90
        }
        return size
    }
}
