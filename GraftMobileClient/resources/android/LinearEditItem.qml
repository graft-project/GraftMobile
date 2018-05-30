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
    property alias inputMask: editItem.inputMask
    property alias echoMode: editItem.echoMode
    property alias passwordCharacter: editItem.passwordCharacter
    property alias inFocus: editItem.focus
    property int fieldCursorPosition: 0

    actionTextField: editItem

    ColumnLayout {
        spacing: -2
        anchors.fill: parent

        Text {
            id: titleItem
            Layout.fillWidth: true
            color: "#BBBBBB"
            font.pixelSize: 12
        }

        TextField {
            id: editItem
            Layout.fillWidth: true
            Layout.fillHeight: true
            cursorPosition: fieldCursorPosition
            rightPadding: visibilityIcon ? 44 : 0
            verticalAlignment: Qt.AlignTop
            color: "#404040"
            maximumLength: letterCountingMode ? linearEditItem.maximumLength : 32767
            Material.accent: wrongFieldColor ? "#F33939" : "#9E9E9E"

            VisibilityIcon {
                Material.accent: "#9E9E9E"
                visible: visibilityIcon
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: 6
                    bottomMargin: 2
                }
                onClicked: passwordMode =! passwordMode
            }
        }
    }
}
