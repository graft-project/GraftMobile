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
    property bool inlineTitle: false

    actionTextField: editItem

    Item {
        id: field
        anchors.fill: parent

        TextField {
            id: editItem
            anchors.fill: parent
            leftPadding: titleItem.width
            rightPadding: visibilityIcon ? 42 : 0
            bottomPadding: 15
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
            font.pointSize: editItem.font.pointSize
            rightPadding: 5
            color: "#8E8E93"
        }

        VisibilityIcon {
            visible: visibilityIcon
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 2
                rightMargin: 6
            }
            onClicked: passwordMode =! passwordMode
        }

        function resizeField() {
            if (editItem.wrapMode !== TextField.NoWrap && !inlineTitle) {
                editItem.topPadding = 30
                editItem.leftPadding = 0
            }
        }
    }
}
