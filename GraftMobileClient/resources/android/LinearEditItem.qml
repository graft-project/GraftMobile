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

    spacing: 8

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
        inputMethodHints: Qt.ImhNoPredictiveText
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
        text: qsTr("%1 / %2").arg(editItem.length).arg(editItem.maximumLength)
        color: "#BBBBBB"
        font.pointSize: 12
    }
}
