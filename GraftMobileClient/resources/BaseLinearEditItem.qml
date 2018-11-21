import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0

ColumnLayout {
    id: root
    property alias attentionText: attentionText.text
    property alias showLengthIndicator: textCount.visible
    property bool visibilityIcon: false
    property bool passwordMode: false
    property bool wrongFieldColor: false
    property bool letterCountingMode: true
    property int maximumLength: 32767
    property var actionTextField: null
    default property alias baseTextField: baseTextField.data

    spacing: -6
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
        id: tipsLayout
        spacing: 0
        Layout.fillWidth: true
        Layout.maximumHeight: 12

        Label {
            id: attentionText
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            visible: visibilityIcon
            color: wrongFieldColor ? "#F33939" : "#3F3F3F"
            font.pixelSize: 12
        }

        Item {
            Layout.fillWidth: true
        }

        Label {
            id: textCount
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            color: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? "#8E8E93" : "#BBBBBB"
            font.pixelSize: 12
            text: qsTr("%1 / %2").arg(letterCountingMode ? actionTextField.displayText.length :
                                  wordCounting(actionTextField.displayText)).arg(maximumLength)
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
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            size = actionTextField.wrapMode === TextField.NoWrap ? 45 : root.height - (tipsLayout.height + root.spacing)
        } else {
            size = actionTextField.wrapMode === TextField.NoWrap ? 55 : root.height - (tipsLayout.height + root.spacing)
        }
        return size
    }
}
