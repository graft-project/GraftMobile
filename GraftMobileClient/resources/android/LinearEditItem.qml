import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout {
    property alias title: titleItem.text
    property alias text: editItem.text
    property alias maximumLength: editItem.maximumLength
    property alias wrapMode: editItem.wrapMode
    property alias inputMethodHints: editItem.inputMethodHints
    property alias validator: editItem.validator
    property alias showLengthIndicator: textCount.visible
    property alias inputMask: editItem.inputMask
    property bool letterCountingMode: true

    function wordCounting() {
        var wordList = editItem.displayText.match(/(\w+)/g)
        if (wordList !== null) {
            return wordList.length
        } else {
            return 0
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
        onWrapModeChanged: {
            if (wrapMode === TextField.NoWrap) {
                Layout.fillHeight = false
            } else {
                Layout.fillHeight = true
                Layout.maximumHeight = 200
            }
        }
    }

    Text {
        id: textCount
        Layout.alignment: Qt.AlignRight
        text: qsTr("%1 / %2").arg(letterCountingMode ? editItem.displayText.length :
                                                       wordCounting()).arg(editItem.maximumLength)
        color: "#BBBBBB"
        font.pointSize: 12
    }
}
