import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    property alias text: message.text
    property alias confirmButton: okButton

    visible: false
    modal: true
    padding: 5
    margins: 30
    contentItem: ColumnLayout {
        spacing: 0

        Label {
            id: message
            Layout.fillWidth: true
            Layout.minimumWidth: 200
            Layout.rightMargin: 20
            Layout.leftMargin: 20
            wrapMode:Text.WordWrap
            font.pixelSize: 15
        }

        Button {
            id: okButton
            flat: true
            text: qsTr("Ok")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
        }
    }
}
