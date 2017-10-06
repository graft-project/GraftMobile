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
    property bool inlineTitle: false
    property alias showLengthIndicator: textCount.visible
    property alias inputMask: editItem.inputMask

    spacing: 0

    TextField {
        id: editItem
        Layout.fillWidth: true
        Layout.bottomMargin: -12
        verticalAlignment: Qt.AlignTop
        color: "#404040"
        leftPadding: titleItem.width
        bottomPadding: 30

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
                }
            }
        }

        onCursorPositionChanged: if(inputMask !== "" && cursorPosition === 3) cursorPosition = 4

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
        text: qsTr("%1/%2").arg(editItem.length).arg(editItem.maximumLength)
        color: "#8e8e93"
    }
}
