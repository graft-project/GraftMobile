import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Button {
    property alias selectIcon: selectIcon.source
    property alias selectText: selectText.text
    property bool visibilityAttentionText: false

    Layout.fillWidth: true
    Layout.preferredHeight: 70
    Material.elevation: 0
    padding: 0
    topPadding: 0
    bottomPadding: 0
    background {
        y: 0
        height: background.parent.height
    }
    enabled: !visibilityAttentionText
    contentItem: Item {
        anchors.fill: parent

//        Rectangle {
//            anchors.fill: parent
//            color: visibilityAttentionText ? "#cecece" : "transparent"

            RowLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: selectIcon
                    Layout.leftMargin: 15
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 50
                    Layout.alignment: Qt.AlignLeft
                    opacity: 0.5
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft

                    Label {
                        id: selectText
                        font.pixelSize: 20
                        color: visibilityAttentionText ? "#818181" : "#3A3E3C"
                    }

                    Label {
                        id: attentionText
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        visible: visibilityAttentionText
                        color: "#60F33939"
                        font.pixelSize: 12
                        text: qsTr("Camera Access is disabled.")
                    }
                }
            }
        }
    }
//}
