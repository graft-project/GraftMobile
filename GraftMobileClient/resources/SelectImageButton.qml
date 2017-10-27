import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Button {
    property alias selectIcon: selectIcon.source
    property alias selectText: selectText.text

    Layout.fillWidth: true
    Layout.preferredHeight: 70
    Material.elevation: 0
    padding: 0
    topPadding: 0
    bottomPadding: 0
    contentItem: Item {
        anchors {
            fill: parent
            leftMargin: 15
        }

        RowLayout {
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: selectIcon
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignLeft
            }

            Text {
                id: selectText
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 20
                color: "#3A3E3C"
            }
        }
    }
}
