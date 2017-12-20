import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout {
    id: linearEditItem
    property alias title: titleItem.text
    property alias text: editItem.text
    property alias wrapMode: editItem.wrapMode
    property alias inputMethodHints: editItem.inputMethodHints
    property alias validator: editItem.validator
    property bool inlineTitle: false
    property alias showLengthIndicator: textCount.visible
    property alias inputMask: editItem.inputMask
    property alias echoMode: editItem.echoMode
    property bool letterCountingMode: true
    property int maximumLength: 0

    function wordCounting() {
        var wordList = editItem.displayText.match(/(\w+)/g)
        if (wordList !== null) {
            return wordList.length
        } else {
            return 0
        }
    }

    spacing: 0

    TextField {
        id: editItem
        Layout.fillWidth: true
        Layout.bottomMargin: -12
        verticalAlignment: Qt.AlignTop
        color: "#404040"
        leftPadding: titleItem.width
        bottomPadding: 30
        maximumLength: letterCountingMode ? linearEditItem.maximumLength : 32767

        onWrapModeChanged: {
            if (wrapMode === TextField.NoWrap) {
                Layout.fillHeight = false
                leftPadding = titleItem.width
                topPadding = 0
            } else {
                Layout.fillHeight = true
                if (!inlineTitle) {
                    leftPadding = 0
                    topPadding = 30
                    Layout.maximumHeight = 200
                }
            }
        }

        Text {
            id: titleItem
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
                topMargin: 8
            }
            font.pointSize: parent.font.pointSize
            rightPadding: 5
            color: "#8e8e93"
        }
    }

    Text {
        id: textCount
        Layout.topMargin: 0
        Layout.alignment: Qt.AlignRight
        font.pointSize: 12
        text: qsTr("%1/%2").arg(letterCountingMode ? editItem.length :
                                                       wordCounting()).arg(maximumLength)
        color: "#8e8e93"
    }
}
