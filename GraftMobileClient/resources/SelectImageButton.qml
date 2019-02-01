import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Button {
    id: selectImageButton

    property alias selectIcon: selectIcon.source
    property alias selectText: selectText.text

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
    contentItem: Item {
        anchors.fill: parent

        RowLayout {
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: selectIcon
                Layout.leftMargin: 10
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignLeft
                opacity: selectImageButton.enabled ? 1.0 : 0.5
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true

                Label {
                    id: selectText
                    font.pixelSize: 20
                    wrapMode: Label.WordWrap
                    Layout.maximumWidth: selectImageButton.width - 70
                    color: selectImageButton.enabled ? "#3A3E3C" : "#99A0AD"
                }

                Label {
                    id: attentionText
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    wrapMode: Label.WordWrap
                    visible: !selectImageButton.enabled
                    color: "#F33939"
                    font.pixelSize: 12
                    text: qsTr("Camera Access is disabled.")
                }
            }
        }
    }
}
