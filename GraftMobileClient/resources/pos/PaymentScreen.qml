import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Item {
    ColumnLayout {
            spacing: 3
            anchors.top: parent.top
            anchors.topMargin: 55
            anchors.left: parent.left
            anchors.leftMargin: 20

        TextField {
            id: title
            placeholderText: "Total: "
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            horizontalAlignment: Text.AlignLeft
            transformOrigin: Item.Center
        }
    }



}
