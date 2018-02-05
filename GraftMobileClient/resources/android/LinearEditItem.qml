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

    actionTextField: editItem

    ColumnLayout {
        spacing: 0
        anchors {
            left: parent.left
            right: parent.right
        }

        Text {
            id: attentionText
            Layout.alignment: Qt.AlignLeft
            visible: visibilityIcon
            font.pixelSize: 12
            color: wrongFieldColor ? "#F33939" : "#3F3F3F"
        }

        Item {
            id: field
            Layout.fillWidth: true
            Layout.preferredHeight: 43

            TextField {
                id: editItem
                anchors.fill: parent
                rightPadding: visibilityIcon ? 44 : 0
                verticalAlignment: Qt.AlignTop
                color: "#404040"
                maximumLength: letterCountingMode ? linearEditItem.maximumLength : 32767
                Material.accent: wrongFieldColor ? "#F33939" : "#9E9E9E"
                onWrapModeChanged: field.resizeField()
            }

            VisibilityIcon {
                visible: visibilityIcon
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: 6
                    bottomMargin: 6
                }
                onClicked: passwordMode =! passwordMode
            }

            function resizeField() {
                if (editItem.wrapMode === TextField.NoWrap) {
                    Layout.fillHeight = false
                } else {
                    Layout.fillHeight = true
                    Layout.preferredHeight = 83
                }
            }
        }
    }
}
