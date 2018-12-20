import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    id: root
    property alias text: message.text

    signal confirmed()

    visible: false
    modal: true
    padding: 5
    margins: 30
    focus: true
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
            id: test
            flat: true
            focus: true
            text: qsTr("Ok")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            onClicked: confirmed()
            Keys.onPressed: {
                if (event.key === Qt.Key_Return) {
                    clicked()
                }
            }
        }
    }
}
